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

cat << YAML > "$FW_FILE"
substitutions:
  name: ${NODE_ID}
  friendly_name: WoMo ${RAW_NAME}

packages:
  device_base: !include base/device_base.yaml
  node_health: !include base/node_health.yaml

# --- ${NODE_CLASS}-specific configuration goes here ---
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
relations:
  uses: []
  topics: []
---

# Node: ${NODE_ID}

## Zweck
Beschreibung der Aufgabe dieses Nodes.

## Node Class
${NODE_CLASS}

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
- YAML-Skelett erzeugt
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
