#include "ad7606_dual_power.h"
#include "esphome/core/log.h"
#include "esphome/components/wifi/wifi_component.h"
#include <cmath>
#include <cstring>

namespace esphome {
namespace ad7606_dual_power {

static const char *const TAG = "ad7606_hwspi";
static const int SAMPLE_COUNT = 32;

bool AD7606DualPower::start_conversion_and_wait_() {
  if (convst_pin_ == nullptr || busy1_pin_ == nullptr || busy2_pin_ == nullptr)
    return false;

  convst_pin_->digital_write(false);
  delayMicroseconds(2);

  convst_pin_->digital_write(true);
  delayMicroseconds(4);
  convst_pin_->digital_write(false);

  const uint32_t t1 = micros();
  while (micros() - t1 < 10000) {
    if (!busy1_pin_->digital_read() && !busy2_pin_->digital_read()) {
      delayMicroseconds(2);
      return true;
    }
  }

  ESP_LOGE(TAG, "Timeout waiting BUSY low: b1=%d b2=%d",
           busy1_pin_->digital_read(), busy2_pin_->digital_read());
  return false;
}

bool AD7606DualPower::read_adc_(GPIOPin *cs_pin, int16_t out[8]) {
  if (cs_pin == nullptr || spi_ == nullptr)
    return false;

  cs_pin->digital_write(false);
  delayMicroseconds(1);

  for (int i = 0; i < 8; i++) {
    spi_transaction_t t;
    std::memset(&t, 0, sizeof(t));
    t.length = 16;
    t.rxlength = 16;
    t.flags = SPI_TRANS_USE_TXDATA | SPI_TRANS_USE_RXDATA;
    t.tx_data[0] = 0x00;
    t.tx_data[1] = 0x00;

    esp_err_t err = spi_device_transmit(spi_, &t);
    if (err != ESP_OK) {
      cs_pin->digital_write(true);
      ESP_LOGE(TAG, "spi_device_transmit failed: %d", (int) err);
      return false;
    }

    uint16_t value = (static_cast<uint16_t>(t.rx_data[0]) << 8) |
                     (static_cast<uint16_t>(t.rx_data[1]));
    out[i] = static_cast<int16_t>(value);
  }

  cs_pin->digital_write(true);
  delayMicroseconds(1);
  return true;
}

void AD7606DualPower::setup() {
  if (cs1_pin_ != nullptr) cs1_pin_->setup();
  if (cs2_pin_ != nullptr) cs2_pin_->setup();
  if (convst_pin_ != nullptr) convst_pin_->setup();
  if (reset_pin_ != nullptr) reset_pin_->setup();
  if (busy1_pin_ != nullptr) busy1_pin_->setup();
  if (busy2_pin_ != nullptr) busy2_pin_->setup();
  if (range_pin_ != nullptr) range_pin_->setup();
  if (os2_pin_ != nullptr) os2_pin_->setup();
  if (os1_pin_ != nullptr) os1_pin_->setup();
  if (os0_pin_ != nullptr) os0_pin_->setup();

  if (cs1_pin_ != nullptr) cs1_pin_->digital_write(true);
  if (cs2_pin_ != nullptr) cs2_pin_->digital_write(true);
  if (convst_pin_ != nullptr) convst_pin_->digital_write(false);

  if (range_pin_ != nullptr) range_pin_->digital_write(false);

  if (oversampling_ == "16x") {
    if (os2_pin_ != nullptr) os2_pin_->digital_write(true);
    if (os1_pin_ != nullptr) os1_pin_->digital_write(false);
    if (os0_pin_ != nullptr) os0_pin_->digital_write(false);
  } else {
    if (os2_pin_ != nullptr) os2_pin_->digital_write(false);
    if (os1_pin_ != nullptr) os1_pin_->digital_write(false);
    if (os0_pin_ != nullptr) os0_pin_->digital_write(false);
  }

  if (reset_pin_ != nullptr) {
    reset_pin_->digital_write(false);
    delayMicroseconds(2);
    reset_pin_->digital_write(true);
    delayMicroseconds(10);
    reset_pin_->digital_write(false);
    delay(2);
  }

  spi_bus_config_t buscfg{};
  buscfg.mosi_io_num = -1;
  buscfg.miso_io_num = GPIO_NUM_13;
  buscfg.sclk_io_num = GPIO_NUM_12;
  buscfg.quadwp_io_num = -1;
  buscfg.quadhd_io_num = -1;
  buscfg.max_transfer_sz = 2;

  esp_err_t err = spi_bus_initialize(SPI2_HOST, &buscfg, SPI_DMA_DISABLED);
  if (err != ESP_OK && err != ESP_ERR_INVALID_STATE) {
    ESP_LOGE(TAG, "spi_bus_initialize failed: %d", (int) err);
    return;
  }

  spi_device_interface_config_t devcfg{};
  devcfg.clock_speed_hz = 1000000;
  devcfg.mode = 0;
  devcfg.spics_io_num = -1;
  devcfg.queue_size = 1;

  err = spi_bus_add_device(SPI2_HOST, &devcfg, &spi_);
  if (err != ESP_OK) {
    ESP_LOGE(TAG, "spi_bus_add_device failed: %d", (int) err);
    spi_ = nullptr;
    return;
  }

  ESP_LOGI(TAG, "Setup complete: HW SPI(IDF) on SCK=GPIO12 MISO=GPIO13, RANGE=LOW, OS=%s",
           oversampling_.c_str());
}

void AD7606DualPower::update() {
  if (wifi::global_wifi_component == nullptr || !wifi::global_wifi_component->is_connected()) {
    ESP_LOGD(TAG, "WiFi not connected yet, skipping measurement");
    return;
  }

  int16_t adc1[8]{};
  int16_t adc2[8]{};

  int16_t current_raw[12][SAMPLE_COUNT]{};
  int16_t voltage_raw[SAMPLE_COUNT]{};

  int16_t adc1_last[8]{};
  int16_t adc2_last[8]{};

  for (int s = 0; s < SAMPLE_COUNT; s++) {
    if (!start_conversion_and_wait_()) {
      ESP_LOGE(TAG, "Conversion failed at sample %d", s);
      return;
    }

    if (!read_adc_(cs1_pin_, adc1)) {
      ESP_LOGE(TAG, "ADC1 read failed at sample %d", s);
      return;
    }
    delayMicroseconds(2);

    if (!read_adc_(cs2_pin_, adc2)) {
      ESP_LOGE(TAG, "ADC2 read failed at sample %d", s);
      return;
    }
    delayMicroseconds(2);

    for (int i = 0; i < 8; i++) {
      adc1_last[i] = adc1[i];
      adc2_last[i] = adc2[i];
    }

    for (int i = 0; i < 6; i++) {
      current_raw[i][s] = adc1[i];
      current_raw[i + 6][s] = adc2[i];
    }

    voltage_raw[s] = adc2[6];
  }

  ESP_LOGI(TAG, "ADC1 raw last sample: %d %d %d %d %d %d %d %d",
           adc1_last[0], adc1_last[1], adc1_last[2], adc1_last[3],
           adc1_last[4], adc1_last[5], adc1_last[6], adc1_last[7]);

  ESP_LOGI(TAG, "ADC2 raw last sample: %d %d %d %d %d %d %d %d",
           adc2_last[0], adc2_last[1], adc2_last[2], adc2_last[3],
           adc2_last[4], adc2_last[5], adc2_last[6], adc2_last[7]);

  float v_sum = 0.0f;
  for (int s = 0; s < SAMPLE_COUNT; s++) {
    v_sum += voltage_raw[s];
  }
  const float v_offset = v_sum / SAMPLE_COUNT;

  float v_sq_sum = 0.0f;
  for (int s = 0; s < SAMPLE_COUNT; s++) {
    const float v = static_cast<float>(voltage_raw[s]) - v_offset;
    v_sq_sum += v * v;
  }

  const float vrms_counts = std::sqrt(v_sq_sum / SAMPLE_COUNT);
  const float voltage = (vrms_counts / 1000.0f) * voltage_scale_;

  if (voltage_rms_sensor_ != nullptr)
    voltage_rms_sensor_->publish_state(voltage);

  if (frequency_sensor_ != nullptr)
    frequency_sensor_->publish_state(mains_hz_);

  for (int ch = 0; ch < 12; ch++) {
    float i_sum = 0.0f;
    for (int s = 0; s < SAMPLE_COUNT; s++) {
      i_sum += current_raw[ch][s];
    }
    const float i_offset = i_sum / SAMPLE_COUNT;

    float i_sq_sum = 0.0f;
    for (int s = 0; s < SAMPLE_COUNT; s++) {
      const float i_val = static_cast<float>(current_raw[ch][s]) - i_offset;
      i_sq_sum += i_val * i_val;
    }

    const float irms_counts = std::sqrt(i_sq_sum / SAMPLE_COUNT);
    const float cur = irms_counts / 1000.0f;

    if (current_rms_[ch] != nullptr)
      current_rms_[ch]->publish_state(cur);

    if (active_power_[ch] != nullptr)
      active_power_[ch]->publish_state(0.0f);
  }

  if (active_power_total_sensor_ != nullptr)
    active_power_total_sensor_->publish_state(0.0f);

  ESP_LOGI(TAG, "RMS publish complete, Voff=%.2f cnt, Vrms=%.3f cnt -> %.2f V",
           v_offset, vrms_counts, voltage);
}

void AD7606DualPower::dump_config() {
  ESP_LOGCONFIG(TAG, "AD7606 Dual Power Node (HW SPI / IDF)");
  LOG_UPDATE_INTERVAL(this);
  ESP_LOGCONFIG(TAG, "  Voltage scale: %.4f", voltage_scale_);
  ESP_LOGCONFIG(TAG, "  Mains Hz: %.1f", mains_hz_);
  ESP_LOGCONFIG(TAG, "  Oversampling: %s", oversampling_.c_str());
}

}  // namespace ad7606_dual_power
}  // namespace esphome
