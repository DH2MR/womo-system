#!/usr/bin/env bash

set -e

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

NODE_CLASS=$1
NODE_NAME=$2
DATE=$(date +%F)

ROOT=$(git rev-parse --show-toplevel)

DOC_DIR="$ROOT/docs/nodes/$NODE_CLASS"
FW_DIR="$ROOT/firmware/esphome"
LOG_DIR="$ROOT/logs/engineering/$(date +%Y)"

DOC_FILE="$DOC_DIR/womo_${NODE_NAME}.md"
FW_FILE="$FW_DIR/womo_${NODE_NAME}.yaml"
LOG_FILE="$LOG_DIR/${DATE}_node_${NODE_NAME}.md"

echo "Creating node: womo_${NODE_NAME}"
echo ""

mkdir -p "$DOC_DIR"
mkdir -p "$LOG_DIR"

# ---- Firmware YAML ----

cat << YAML > "$FW_FILE"
esphome:
  name: womo_${NODE_NAME}
  friendly_name: WoMo ${NODE_NAME}

esp32:
  board: esp32-s3-devkitc-1
  framework:
    type: arduino

logger:

wifi:
  ssid: !secret wifi_ssid_2g
  password: !secret wifi_password_2g
  power_save_mode: none

mqtt:
  broker: 10.10.64.10
  username: esphome
  password: womo_mqtt_2026

ota:
  - platform: esphome

# --- sensors / components go here ---
YAML

# ---- Node documentation ----

cat << DOC > "$DOC_FILE"
---
id: node.womo_${NODE_NAME}
type: node
class: ${NODE_CLASS}
status: draft
owner: engineering
last_updated: ${DATE}
tags:
  - esp32-s3-zero
relations:
  uses: []
---

# Node: womo_${NODE_NAME}

## Zweck

Beschreibung der Aufgabe dieses Nodes.

## Node Class

${NODE_CLASS}

## Hardware

Controller:
ESP32-S3 Zero

Sensoren / Interfaces:
TBD

## Firmware

ESPHome Node:
womo_${NODE_NAME}

YAML:
firmware/esphome/womo_${NODE_NAME}.yaml

## MQTT Topics

Publish:

womo/<domain>/<entity>/<metric>

Subscribe:

optional

## Status

- [ ] Hardware definiert
- [ ] Firmware erstellt
- [ ] MQTT Topics definiert
- [ ] Node getestet
DOC

# ---- Engineering log ----

cat << LOG > "$LOG_FILE"
# Engineering Log

Date: ${DATE}

Topic:
Node creation womo_${NODE_NAME}

## Node Class

${NODE_CLASS}

## Goal

Initial creation of node skeleton.

## Created files

- ${FW_FILE}
- ${DOC_FILE}

## Next steps

- hardware design
- sensor integration
- mqtt topics
LOG

echo "Created:"
echo "  $FW_FILE"
echo "  $DOC_FILE"
echo "  $LOG_FILE"
echo ""
echo "Node skeleton ready."
