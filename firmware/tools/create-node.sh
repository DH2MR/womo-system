#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: create-node.sh <class> <name>"
  echo ""
  echo "Classes:"
  echo "  sensor"
  echo "  power"
  echo "  control"
  echo "  system"
  echo "  gateway"
  echo "  lab"
  exit 1
fi

NODE_CLASS="$1"
RAW_NAME="$2"
DATE="$(date +%F)"
YEAR="$(date +%Y)"

case "$NODE_CLASS" in
  sensor|power|control|system|gateway|lab)
    ;;
  *)
    echo "Error: invalid class '$NODE_CLASS'"
    exit 1
    ;;
esac

ROOT="$(git rev-parse --show-toplevel)"
DOC_DIR="$ROOT/docs/nodes/$NODE_CLASS"
FW_DIR="$ROOT/firmware/esphome"
LOG_DIR="$ROOT/logs/engineering/$YEAR"

NODE_ID="womo_${RAW_NAME}"
DOC_FILE="$DOC_DIR/${NODE_ID}.md"
FW_FILE="$FW_DIR/${NODE_ID}.yaml"
LOG_FILE="$LOG_DIR/${DATE}_node_${RAW_NAME}.md"

if [ -e "$DOC_FILE" ] || [ -e "$FW_FILE" ] || [ -e "$LOG_FILE" ]; then
  echo "Error: one or more target files already exist."
  echo "  $FW_FILE"
  echo "  $DOC_FILE"
  echo "  $LOG_FILE"
  exit 1
fi

mkdir -p "$DOC_DIR" "$FW_DIR" "$LOG_DIR"

build_firmware_block() {
  case "$NODE_CLASS" in
    sensor)
      cat << 'YAML'
# --- sensor-specific configuration ---

i2c:
  sda: GPIO8
  scl: GPIO9
  scan: true

# onewire:
#   - platform: gpio
#     pin: GPIO2

# sensor:
#   - platform: dallas_temp
#     address: 0x0000000000000000
#     name: "${friendly_name} Temperature"
YAML
      ;;
    power)
      cat << 'YAML'
# --- power-specific configuration ---

# Example placeholder for power measurement nodes.
# Replace with custom component or ADC configuration.

# spi:
#   clk_pin: GPIO12
#   mosi_pin: GPIO11
#   miso_pin: GPIO13

# sensor:
#   - platform: template
#     name: "${friendly_name} Voltage"
#     unit_of_measurement: "V"
#   - platform: template
#     name: "${friendly_name} Current"
#     unit_of_measurement: "A"
#   - platform: template
#     name: "${friendly_name} Power"
#     unit_of_measurement: "W"

# calibration:
#   voltage_scale: 1.0
#   current_scale: 1.0
YAML
      ;;
    control)
      cat << 'YAML'
# --- control-specific configuration ---

# Example command/state structure.

# output:
#   - platform: gpio
#     pin: GPIO2
#     id: relay_output

# switch:
#   - platform: output
#     name: "${friendly_name} Relay"
#     output: relay_output

# binary_sensor:
#   - platform: gpio
#     pin:
#       number: GPIO3
#       mode: INPUT_PULLUP
#     name: "${friendly_name} Feedback"
YAML
      ;;
    system)
      cat << 'YAML'
# --- system-specific configuration ---

# Add diagnostic, watchdog, heartbeat or infrastructure sensors here.

# sensor:
#   - platform: internal_temperature
#     name: "${friendly_name} MCU Temperature"
YAML
      ;;
    gateway)
      cat << 'YAML'
# --- gateway-specific configuration ---

# Add protocol bridge configuration here, e.g. UART, RS485, Modbus, CAN.

# uart:
#   tx_pin: GPIO17
#   rx_pin: GPIO18
#   baud_rate: 9600
YAML
      ;;
    lab)
      cat << 'YAML'
# --- lab-specific configuration ---

# Experimental node.
# Use for temporary hardware tests, bus scans or validation setups.

# logger:
#   level: DEBUG
YAML
      ;;
  esac
}

build_doc_block() {
  case "$NODE_CLASS" in
    sensor)
      cat << 'DOC'
## Klassenhinweise
- Typisch publish-lastig
- geringe bis mittlere Rechenlast
- geeignet für Umwelt- und Zustandsdaten

## Typische Topics
- womo/climate/<location>/<metric>
- womo/water/<tank>/<metric>
- womo/system/<node>/status
DOC
      ;;
    power)
      cat << 'DOC'
## Klassenhinweise
- höhere technische Kritikalität
- Kalibrierung dokumentieren
- Messpfad und Berechnungen sauber beschreiben

## Typische Topics
- womo/power/<device>/<channel>/<metric>
- womo/power/total/<metric>
- womo/system/<node>/status
DOC
      ;;
    control)
      cat << 'DOC'
## Klassenhinweise
- Safe State definieren
- Bootverhalten dokumentieren
- Soll-/Ist-Zustände trennen

## Typische Topics
- womo/control/<device>/cmd
- womo/control/<device>/state
- womo/control/<device>/fault
DOC
      ;;
    system)
      cat << 'DOC'
## Klassenhinweise
- Fokus auf Monitoring und Health
- Diagnose- und Metadaten bereitstellen

## Typische Topics
- womo/system/<node>/status
- womo/system/<node>/uptime
- womo/system/<node>/wifi_rssi
DOC
      ;;
    gateway)
      cat << 'DOC'
## Klassenhinweise
- Protokollmapping dokumentieren
- Timeouts und Fehlerpfade festhalten

## Typische Topics
- womo/gateway/<bridge>/<metric>
- womo/system/<node>/status
DOC
      ;;
    lab)
      cat << 'DOC'
## Klassenhinweise
- nicht produktiv
- Erkenntnisse später in produktive Node-Klasse überführen

## Typische Topics
- womo/debug/<node>/<message>
- womo/system/<node>/status
DOC
      ;;
  esac
}

cat << YAML > "$FW_FILE"
substitutions:
  name: ${NODE_ID}
  friendly_name: WoMo ${RAW_NAME}

packages:
  device_base: !include base/device_base.yaml
  node_health: !include base/node_health.yaml

$(build_firmware_block)
YAML

cat << DOC > "$DOC_FILE"
---
id: node.${NODE_ID}
type: node
class: ${NODE_CLASS}
status: draft
owner: engineering
last_updated: ${DATE}
tags:
  - esp32-s3-zero
  - ${NODE_CLASS}
relations:
  uses: []
  topics: []
---

# Node: ${NODE_ID}

## Zweck
Beschreibung der Aufgabe dieses Nodes.

## Node Class
${NODE_CLASS}

$(build_doc_block)

## Status
- Status: draft
- Deployment State:
- Kritikalität:

## Hardware

### Controller
- Board: ESP32-S3 Zero
- MCU: ESP32-S3
- Versorgung:

### Sensoren / Interfaces
- TBD

## Pinbelegung

| Signal | GPIO | Richtung | Beschreibung |
|---|---:|---|---|

## Firmware
- ESPHome Node Name: ${NODE_ID}
- Friendly Name: WoMo ${RAW_NAME}
- YAML-Datei: firmware/esphome/${NODE_ID}.yaml
- Base Packages:
  - firmware/esphome/base/device_base.yaml
  - firmware/esphome/base/node_health.yaml

## Netzwerk
- WLAN: womo_2G
- DHCP Reservation: vorgesehen
- MQTT Broker: 10.10.64.10:1883

## MQTT

### Publish Topics
| Topic | Payload | Beschreibung |
|---|---|---|

### Subscribe Topics
| Topic | Payload | Beschreibung |
|---|---|---|

## Messgrößen / Funktionen
- TBD

## Kalibrierung
- TBD

## Betriebsverhalten
- Boot-Verhalten:
- Update-Verhalten:
- Fehlerverhalten:

## Bekannte Risiken / Grenzen
- TBD

## Teststatus
- [ ] Kompiliert
- [ ] OTA erfolgreich
- [ ] MQTT verbunden
- [ ] Sensordaten plausibel
- [ ] Langzeittest bestanden

## Verknüpfte Dokumente
- ADRs:
- Debugging:
- Runbooks:
- Schaltplan / PCB:
DOC

cat << LOG > "$LOG_FILE"
---
id: englog.node_${RAW_NAME}
type: engineering-log
date: ${DATE}
owner: engineering
topic: node-creation
status: active
tags:
  - ${NODE_CLASS}
  - ${NODE_ID}
---

# Engineering Log: Create ${NODE_ID}

## Ziel des Arbeitsschritts
Initiale Anlage eines neuen Node-Skeletts.

## Ausgangslage
Neuer ${NODE_CLASS}-Node wird im Repository angelegt.

## Änderungen
- YAML-Skelett mit Base-Packages erzeugt
- klassenspezifische Vorlage erzeugt
- Node-Dokumentation erzeugt
- Engineering-Log erzeugt

## Erzeugte Dateien
- firmware/esphome/${NODE_ID}.yaml
- docs/nodes/${NODE_CLASS}/${NODE_ID}.md
- logs/engineering/${YEAR}/${DATE}_node_${RAW_NAME}.md

## Nächste Schritte
- Hardware spezifizieren
- MQTT Topics definieren
- Firmware konfigurieren
- Tests durchführen
LOG

echo "Created:"
echo "  $FW_FILE"
echo "  $DOC_FILE"
echo "  $LOG_FILE"
