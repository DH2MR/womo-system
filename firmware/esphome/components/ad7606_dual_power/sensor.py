import esphome.codegen as cg
import esphome.config_validation as cv
from esphome import pins
from esphome.cpp_helpers import gpio_pin_expression
from esphome.components import sensor
from esphome.const import (
    CONF_ID,
    DEVICE_CLASS_CURRENT,
    DEVICE_CLASS_FREQUENCY,
    DEVICE_CLASS_POWER,
    DEVICE_CLASS_VOLTAGE,
    STATE_CLASS_MEASUREMENT,
    UNIT_AMPERE,
    UNIT_HERTZ,
    UNIT_VOLT,
    UNIT_WATT,
)

CONF_CS1_PIN = "cs1_pin"
CONF_CS2_PIN = "cs2_pin"
CONF_CONVST_PIN = "convst_pin"
CONF_RESET_PIN = "reset_pin"
CONF_BUSY1_PIN = "busy1_pin"
CONF_BUSY2_PIN = "busy2_pin"
CONF_RANGE_PIN = "range_pin"
CONF_OS2_PIN = "os2_pin"
CONF_OS1_PIN = "os1_pin"
CONF_OS0_PIN = "os0_pin"
CONF_OVERSAMPLING = "oversampling"
CONF_MAINS_HZ = "mains_hz"
CONF_VOLTAGE_SCALE = "voltage_scale"

CONF_VOLTAGE_RMS = "voltage_rms"
CONF_FREQUENCY = "frequency"
CONF_ACTIVE_POWER_TOTAL = "active_power_total"

ad7606_ns = cg.esphome_ns.namespace("ad7606_dual_power")
AD7606DualPower = ad7606_ns.class_("AD7606DualPower", cg.PollingComponent)


def chan_sensor_schema(unit, device_class):
    return sensor.sensor_schema(
        unit_of_measurement=unit,
        accuracy_decimals=2 if unit in [UNIT_AMPERE, UNIT_VOLT] else 1,
        device_class=device_class,
        state_class=STATE_CLASS_MEASUREMENT,
    )


CONFIG_SCHEMA = cv.Schema(
    {
        cv.GenerateID(): cv.declare_id(AD7606DualPower),

        cv.Required(CONF_CS1_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_CS2_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_CONVST_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_RESET_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_BUSY1_PIN): pins.internal_gpio_input_pin_schema,
        cv.Required(CONF_BUSY2_PIN): pins.internal_gpio_input_pin_schema,
        cv.Required(CONF_RANGE_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_OS2_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_OS1_PIN): pins.internal_gpio_output_pin_schema,
        cv.Required(CONF_OS0_PIN): pins.internal_gpio_output_pin_schema,

        cv.Optional(CONF_OVERSAMPLING, default="16x"): cv.string,
        cv.Optional(CONF_MAINS_HZ, default=50.0): cv.float_,
        cv.Optional(CONF_VOLTAGE_SCALE, default=11.5): cv.float_,

        cv.Optional(CONF_VOLTAGE_RMS): chan_sensor_schema(
            UNIT_VOLT, DEVICE_CLASS_VOLTAGE
        ),
        cv.Optional(CONF_FREQUENCY): chan_sensor_schema(
            UNIT_HERTZ, DEVICE_CLASS_FREQUENCY
        ),
        cv.Optional(CONF_ACTIVE_POWER_TOTAL): chan_sensor_schema(
            UNIT_WATT, DEVICE_CLASS_POWER
        ),

        cv.Optional("current_rms_ch1"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch2"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch3"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch4"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch5"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch6"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch7"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch8"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch9"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch10"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch11"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),
        cv.Optional("current_rms_ch12"): chan_sensor_schema(UNIT_AMPERE, DEVICE_CLASS_CURRENT),

        cv.Optional("active_power_ch1"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch2"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch3"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch4"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch5"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch6"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch7"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch8"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch9"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch10"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch11"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
        cv.Optional("active_power_ch12"): chan_sensor_schema(UNIT_WATT, DEVICE_CLASS_POWER),
    }
).extend(cv.polling_component_schema("1s"))


async def to_code(config):
    var = cg.new_Pvariable(config[CONF_ID])
    await cg.register_component(var, config)

    cs1 = await gpio_pin_expression(config[CONF_CS1_PIN])
    cs2 = await gpio_pin_expression(config[CONF_CS2_PIN])
    convst = await gpio_pin_expression(config[CONF_CONVST_PIN])
    reset = await gpio_pin_expression(config[CONF_RESET_PIN])
    busy1 = await gpio_pin_expression(config[CONF_BUSY1_PIN])
    busy2 = await gpio_pin_expression(config[CONF_BUSY2_PIN])
    range_pin = await gpio_pin_expression(config[CONF_RANGE_PIN])
    os2 = await gpio_pin_expression(config[CONF_OS2_PIN])
    os1 = await gpio_pin_expression(config[CONF_OS1_PIN])
    os0 = await gpio_pin_expression(config[CONF_OS0_PIN])

    cg.add(var.set_cs1_pin(cs1))
    cg.add(var.set_cs2_pin(cs2))
    cg.add(var.set_convst_pin(convst))
    cg.add(var.set_reset_pin(reset))
    cg.add(var.set_busy1_pin(busy1))
    cg.add(var.set_busy2_pin(busy2))
    cg.add(var.set_range_pin(range_pin))
    cg.add(var.set_os2_pin(os2))
    cg.add(var.set_os1_pin(os1))
    cg.add(var.set_os0_pin(os0))

    cg.add(var.set_voltage_scale(config[CONF_VOLTAGE_SCALE]))
    cg.add(var.set_mains_hz(config[CONF_MAINS_HZ]))
    cg.add(var.set_oversampling(config[CONF_OVERSAMPLING]))

    for key, setter in [
        (CONF_VOLTAGE_RMS, "set_voltage_rms_sensor"),
        (CONF_FREQUENCY, "set_frequency_sensor"),
        (CONF_ACTIVE_POWER_TOTAL, "set_active_power_total_sensor"),
        ("current_rms_ch1", "set_current_rms_ch1_sensor"),
        ("current_rms_ch2", "set_current_rms_ch2_sensor"),
        ("current_rms_ch3", "set_current_rms_ch3_sensor"),
        ("current_rms_ch4", "set_current_rms_ch4_sensor"),
        ("current_rms_ch5", "set_current_rms_ch5_sensor"),
        ("current_rms_ch6", "set_current_rms_ch6_sensor"),
        ("current_rms_ch7", "set_current_rms_ch7_sensor"),
        ("current_rms_ch8", "set_current_rms_ch8_sensor"),
        ("current_rms_ch9", "set_current_rms_ch9_sensor"),
        ("current_rms_ch10", "set_current_rms_ch10_sensor"),
        ("current_rms_ch11", "set_current_rms_ch11_sensor"),
        ("current_rms_ch12", "set_current_rms_ch12_sensor"),
        ("active_power_ch1", "set_active_power_ch1_sensor"),
        ("active_power_ch2", "set_active_power_ch2_sensor"),
        ("active_power_ch3", "set_active_power_ch3_sensor"),
        ("active_power_ch4", "set_active_power_ch4_sensor"),
        ("active_power_ch5", "set_active_power_ch5_sensor"),
        ("active_power_ch6", "set_active_power_ch6_sensor"),
        ("active_power_ch7", "set_active_power_ch7_sensor"),
        ("active_power_ch8", "set_active_power_ch8_sensor"),
        ("active_power_ch9", "set_active_power_ch9_sensor"),
        ("active_power_ch10", "set_active_power_ch10_sensor"),
        ("active_power_ch11", "set_active_power_ch11_sensor"),
        ("active_power_ch12", "set_active_power_ch12_sensor"),
    ]:
        if key in config:
            sens = await sensor.new_sensor(config[key])
            cg.add(getattr(var, setter)(sens))
