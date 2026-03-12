#pragma once

#include "esphome/core/component.h"
#include "esphome/components/sensor/sensor.h"
#include "esphome/core/hal.h"
#include <driver/spi_master.h>
#include <string>

namespace esphome {
namespace ad7606_dual_power {

class AD7606DualPower : public PollingComponent {
 public:
  void setup() override;
  void update() override;
  void dump_config() override;

  void set_cs1_pin(GPIOPin *pin) { cs1_pin_ = pin; }
  void set_cs2_pin(GPIOPin *pin) { cs2_pin_ = pin; }
  void set_convst_pin(GPIOPin *pin) { convst_pin_ = pin; }
  void set_reset_pin(GPIOPin *pin) { reset_pin_ = pin; }
  void set_busy1_pin(GPIOPin *pin) { busy1_pin_ = pin; }
  void set_busy2_pin(GPIOPin *pin) { busy2_pin_ = pin; }
  void set_range_pin(GPIOPin *pin) { range_pin_ = pin; }
  void set_os2_pin(GPIOPin *pin) { os2_pin_ = pin; }
  void set_os1_pin(GPIOPin *pin) { os1_pin_ = pin; }
  void set_os0_pin(GPIOPin *pin) { os0_pin_ = pin; }

  void set_voltage_scale(float v) { voltage_scale_ = v; }
  void set_mains_hz(float hz) { mains_hz_ = hz; }
  void set_oversampling(const std::string &os) { oversampling_ = os; }

  void set_voltage_rms_sensor(sensor::Sensor *s) { voltage_rms_sensor_ = s; }
  void set_frequency_sensor(sensor::Sensor *s) { frequency_sensor_ = s; }
  void set_active_power_total_sensor(sensor::Sensor *s) { active_power_total_sensor_ = s; }

  void set_current_rms_ch1_sensor(sensor::Sensor *s) { current_rms_[0] = s; }
  void set_current_rms_ch2_sensor(sensor::Sensor *s) { current_rms_[1] = s; }
  void set_current_rms_ch3_sensor(sensor::Sensor *s) { current_rms_[2] = s; }
  void set_current_rms_ch4_sensor(sensor::Sensor *s) { current_rms_[3] = s; }
  void set_current_rms_ch5_sensor(sensor::Sensor *s) { current_rms_[4] = s; }
  void set_current_rms_ch6_sensor(sensor::Sensor *s) { current_rms_[5] = s; }
  void set_current_rms_ch7_sensor(sensor::Sensor *s) { current_rms_[6] = s; }
  void set_current_rms_ch8_sensor(sensor::Sensor *s) { current_rms_[7] = s; }
  void set_current_rms_ch9_sensor(sensor::Sensor *s) { current_rms_[8] = s; }
  void set_current_rms_ch10_sensor(sensor::Sensor *s) { current_rms_[9] = s; }
  void set_current_rms_ch11_sensor(sensor::Sensor *s) { current_rms_[10] = s; }
  void set_current_rms_ch12_sensor(sensor::Sensor *s) { current_rms_[11] = s; }

  void set_active_power_ch1_sensor(sensor::Sensor *s) { active_power_[0] = s; }
  void set_active_power_ch2_sensor(sensor::Sensor *s) { active_power_[1] = s; }
  void set_active_power_ch3_sensor(sensor::Sensor *s) { active_power_[2] = s; }
  void set_active_power_ch4_sensor(sensor::Sensor *s) { active_power_[3] = s; }
  void set_active_power_ch5_sensor(sensor::Sensor *s) { active_power_[4] = s; }
  void set_active_power_ch6_sensor(sensor::Sensor *s) { active_power_[5] = s; }
  void set_active_power_ch7_sensor(sensor::Sensor *s) { active_power_[6] = s; }
  void set_active_power_ch8_sensor(sensor::Sensor *s) { active_power_[7] = s; }
  void set_active_power_ch9_sensor(sensor::Sensor *s) { active_power_[8] = s; }
  void set_active_power_ch10_sensor(sensor::Sensor *s) { active_power_[9] = s; }
  void set_active_power_ch11_sensor(sensor::Sensor *s) { active_power_[10] = s; }
  void set_active_power_ch12_sensor(sensor::Sensor *s) { active_power_[11] = s; }

 protected:
  bool start_conversion_and_wait_();
  bool read_adc_(GPIOPin *cs_pin, int16_t out[8]);

  GPIOPin *cs1_pin_{nullptr};
  GPIOPin *cs2_pin_{nullptr};
  GPIOPin *convst_pin_{nullptr};
  GPIOPin *reset_pin_{nullptr};
  GPIOPin *busy1_pin_{nullptr};
  GPIOPin *busy2_pin_{nullptr};
  GPIOPin *range_pin_{nullptr};
  GPIOPin *os2_pin_{nullptr};
  GPIOPin *os1_pin_{nullptr};
  GPIOPin *os0_pin_{nullptr};

  spi_device_handle_t spi_{nullptr};

  float voltage_scale_{11.5f};
  float mains_hz_{50.0f};
  std::string oversampling_{"16x"};

  sensor::Sensor *voltage_rms_sensor_{nullptr};
  sensor::Sensor *frequency_sensor_{nullptr};
  sensor::Sensor *active_power_total_sensor_{nullptr};
  sensor::Sensor *current_rms_[12]{};
  sensor::Sensor *active_power_[12]{};
};

}  // namespace ad7606_dual_power
}  // namespace esphome
