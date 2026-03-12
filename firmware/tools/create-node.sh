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
RAW_INPUT="$2"
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

normalize_slug() {
  echo "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed 's/^womo[-_]//g' \
    | sed 's/[_[:space:]]\+/-/g' \
    | sed 's/--\+/-/g' \
    | sed 's/^-//; s/-$//'
}

make_friendly_name() {
  echo "$1" \
    | sed 's/^womo[-_]//g' \
    | sed 's/[-_]/ /g' \
    | awk '{
        for (i=1; i<=NF; i++) {
          $i=toupper(substr($i,1,1)) substr($i,2)
        }
        print
      }'
}

NODE_SLUG="$(normalize_slug "$RAW_INPUT")"
NODE_ID="womo-${NODE_SLUG}"
FRIENDLY_SUFFIX="$(make_friendly_name "$RAW_INPUT")"
FRIENDLY_NAME="WoMo ${FRIENDLY_SUFFIX}"

DOC_FILE="$DOC_DIR/${NODE_ID}.md"
FW_FILE="$FW_DIR/${NODE_ID}.yaml"
LOG_FILE="$LOG_DIR/${DATE}_node_${NODE_SLUG}.md"

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
  id: bus_i2c
  sda: GPIO8
  scl: GPIO9
  scan: true

# onewire:
#   - platform: gpio
#     pin: GPIO2

# sensor:
#   - platform: sht3xd
#     i2c_id: bus_i2c
#     temperature:
#       name: "${friendly_name} Temperature"
#     humidity:
#       name: "${friendly_name} Humidity"
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
YAML
      ;;
    control)
      cat << 'YAML'
# --- control-specific configuration ---

# output:
#   - platform: gpio
#     pin: GPIO2
#     id: relay_output

# switch:
#   - platform: output
#     name: "${friendly_name} Relay"
#     output: relay_output
YAML
      ;;
    system)
      cat << 'YAML'
# --- system-specific configuration ---

# sensor:
#   - platform: internal_temperature
#     name: "${friendly_name} MCU Temperature"
YAML
      ;;
    gateway)
      cat << 'YAML'
# --- gateway-specific configuration ---

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
DOC
      ;;
    power)
      cat << 'DOC'
## Klassenhinweise
- höhere technische Kritikalität
- Kalibrierung dokumentieren
- Messpfad und Berechnungen sauber beschreiben
DOC
      ;;
    control)
      cat << 'DOC'
## Klassenhinweise
- Safe State definieren
- Bootverhalten dokumentieren
- Soll-/Ist-Zustände trennen
DOC
      ;;
    system)
      cat << 'DOC'
## Klassenhinweise
- Fokus auf Monitoring und Health
- Diagnose- und Metadaten bereitstellen
DOC
      ;;
    gateway)
      cat << 'DOC'
## Klassenhinweise
- Protokollmapping dokumentieren
- Timeouts und Fehlerpfade festhalten
DOC
      ;;
    lab)
      cat << 'DOC'
## Klassenhinweise
- nicht produktiv
- Erkenntnisse später in produktive Node-Klasse überführen
DOC
      ;;
  esac
}

cat << YAML > "$FW_FILE"
substitutions:
  name: ${NODE_ID}
  friendly_name: ${FRIENDLY_NAME}

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
- Friendly Name: ${FRIENDLY_NAME}
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
id: englog.node_${NODE_SLUG}
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
- logs/engineering/${YEAR}/${DATE}_node_${NODE_SLUG}.md

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
