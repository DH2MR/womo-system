---
id: node.womo_climate_wohnraum
type: node
class: sensor
status: draft
owner: engineering
last_updated: 2026-03-12
tags:
  - esp32-s3-zero
  - sensor
relations:
  uses: []
  topics: []
---

# Node: womo_climate_wohnraum

## Zweck
Beschreibung der Aufgabe dieses Nodes.

## Node Class
sensor

## Klassenhinweise
- Typisch publish-lastig
- geringe bis mittlere Rechenlast
- geeignet für Umwelt- und Zustandsdaten

## Typische Topics
- womo/climate/<location>/<metric>
- womo/water/<tank>/<metric>
- womo/system/<node>/status

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
- ESPHome Node Name: womo_climate_wohnraum
- Friendly Name: WoMo climate_wohnraum
- YAML-Datei: firmware/esphome/womo_climate_wohnraum.yaml
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
