---
id: node.womo-power-measurement
type: node
class: power
status: active
owner: engineering
last_updated: 2026-03-12
tags:
  - esp32-s3-zero
  - power
  - ad7606
relations:
  uses:
    - firmware/esphome/base/device_base.yaml
    - firmware/esphome/base/node_health.yaml
    - firmware/esphome/common/diag_basic.yaml
    - firmware/esphome/sensors/ad7606_dual_power.yaml
    - firmware/esphome/components/ad7606_dual_power/
  topics:
    - womo/system/womo-power-measurement/status
    - womo/system/womo-power-measurement/ip
    - womo/system/womo-power-measurement/restart_reason
    - womo/system/womo-power-measurement/uptime
    - womo/system/womo-power-measurement/wifi_rssi
    - womo/system/womo-power-measurement/heap_free
    - womo/power/ac/voltage
    - womo/power/ac/frequency
    - womo/power/total/real_power
    - womo/power/channel/ch1/current
    - womo/power/channel/ch1/real_power
    - womo/power/channel/ch2/current
    - womo/power/channel/ch2/real_power
    - womo/power/channel/ch3/current
    - womo/power/channel/ch3/real_power
    - womo/power/channel/ch4/current
    - womo/power/channel/ch4/real_power
    - womo/power/channel/ch5/current
    - womo/power/channel/ch5/real_power
    - womo/power/channel/ch6/current
    - womo/power/channel/ch6/real_power
    - womo/power/channel/ch7/current
    - womo/power/channel/ch7/real_power
    - womo/power/channel/ch8/current
    - womo/power/channel/ch8/real_power
    - womo/power/channel/ch9/current
    - womo/power/channel/ch9/real_power
    - womo/power/channel/ch10/current
    - womo/power/channel/ch10/real_power
    - womo/power/channel/ch11/current
    - womo/power/channel/ch11/real_power
    - womo/power/channel/ch12/current
    - womo/power/channel/ch12/real_power
---

# Node: womo-power-measurement

## Zweck

AC-Leistungsmess-Node für das WoMo-System.

Erfasst:

- Netzspannung RMS
- Netzfrequenz
- Strom RMS für 12 Kanäle
- Wirkleistung je Kanal
- Gesamtwirkleistung

Zusätzlich publiziert der Node standardisierte System- und Health-Daten.

## Node Class

power

## Klassenhinweise

- publish-lastig
- hohe Mess- und Rechenaktivität
- 1 s Update-Zyklus
- Grundlage für Energieanalyse und spätere Agent-Auswertung

## Status

- Status: active
- Deployment State: deployed
- Kritikalität: high

## Hardware

### Controller

- Board: ESP32-S3 Zero
- MCU: ESP32-S3

### ADC / Messfrontend

- 2 × AD7606
- Betriebsart: Serial / HW SPI
- Oversampling: 16x
- Range: ±5 V

### Messkanäle

- 12 Stromkanäle
- 1 Spannungsmessung
- Frequenzberechnung
- Gesamtwirkleistung

## Pinbelegung

| Signal | GPIO | Richtung | Beschreibung |
|---|---:|---|---|
| SCK | 12 | out | SPI Clock |
| MISO | 13 | in | SPI MISO |
| CS1 | 10 | out | ADC1 Chip Select |
| CS2 | 9 | out | ADC2 Chip Select |
| CONVST | 8 | out | Start Conversion |
| RESET | 7 | out | ADC Reset |
| BUSY1 | 6 | in | ADC1 Busy |
| BUSY2 | 5 | in | ADC2 Busy |
| RANGE | 4 | out | Eingangsbereich |
| OS2 | 3 | out | Oversampling Bit 2 |
| OS1 | 2 | out | Oversampling Bit 1 |
| OS0 | 11 | out | Oversampling Bit 0 |

## Firmware

- ESPHome Node Name: womo-power-measurement
- Friendly Name: WoMo Power Measurement
- YAML-Datei: firmware/esphome/womo-power-measurement.yaml

### Eingebundene Pakete

- firmware/esphome/base/device_base.yaml
- firmware/esphome/base/node_health.yaml
- firmware/esphome/common/diag_basic.yaml
- firmware/esphome/sensors/ad7606_dual_power.yaml

### Custom Component

- firmware/esphome/components/ad7606_dual_power/

## Netzwerk

- WLAN: womo_2G
- DHCP Reservation: aktiv
- MQTT Broker: 10.10.64.10:1883

## MQTT

### Publish Topics: System / Health

| Topic | Payload | Beschreibung |
|---|---|---|
| womo/system/womo-power-measurement/status | online / offline | Node-Verfügbarkeit |
| womo/system/womo-power-measurement/ip | String | aktuelle IP-Adresse |
| womo/system/womo-power-measurement/restart_reason | String | Neustartgrund |
| womo/system/womo-power-measurement/uptime | Integer | Laufzeit seit Boot in s |
| womo/system/womo-power-measurement/wifi_rssi | Integer | WLAN-Signalstärke in dBm |
| womo/system/womo-power-measurement/heap_free | Integer | freier Heap in Byte |

### Publish Topics: Power

| Topic | Payload | Beschreibung |
|---|---|---|
| womo/power/ac/voltage | Float | Netzspannung RMS |
| womo/power/ac/frequency | Float | Netzfrequenz |
| womo/power/total/real_power | Float | Gesamtwirkleistung |
| womo/power/channel/ch1/current | Float | Strom RMS Kanal 1 |
| womo/power/channel/ch1/real_power | Float | Wirkleistung Kanal 1 |
| womo/power/channel/ch2/current | Float | Strom RMS Kanal 2 |
| womo/power/channel/ch2/real_power | Float | Wirkleistung Kanal 2 |
| womo/power/channel/ch3/current | Float | Strom RMS Kanal 3 |
| womo/power/channel/ch3/real_power | Float | Wirkleistung Kanal 3 |
| womo/power/channel/ch4/current | Float | Strom RMS Kanal 4 |
| womo/power/channel/ch4/real_power | Float | Wirkleistung Kanal 4 |
| womo/power/channel/ch5/current | Float | Strom RMS Kanal 5 |
| womo/power/channel/ch5/real_power | Float | Wirkleistung Kanal 5 |
| womo/power/channel/ch6/current | Float | Strom RMS Kanal 6 |
| womo/power/channel/ch6/real_power | Float | Wirkleistung Kanal 6 |
| womo/power/channel/ch7/current | Float | Strom RMS Kanal 7 |
| womo/power/channel/ch7/real_power | Float | Wirkleistung Kanal 7 |
| womo/power/channel/ch8/current | Float | Strom RMS Kanal 8 |
| womo/power/channel/ch8/real_power | Float | Wirkleistung Kanal 8 |
| womo/power/channel/ch9/current | Float | Strom RMS Kanal 9 |
| womo/power/channel/ch9/real_power | Float | Wirkleistung Kanal 9 |
| womo/power/channel/ch10/current | Float | Strom RMS Kanal 10 |
| womo/power/channel/ch10/real_power | Float | Wirkleistung Kanal 10 |
| womo/power/channel/ch11/current | Float | Strom RMS Kanal 11 |
| womo/power/channel/ch11/real_power | Float | Wirkleistung Kanal 11 |
| womo/power/channel/ch12/current | Float | Strom RMS Kanal 12 |
| womo/power/channel/ch12/real_power | Float | Wirkleistung Kanal 12 |

### Legacy Topics

Der Node publiziert aktuell zusätzlich weiterhin ESPHome-Default-Topics unter dem alten Schema.

Beispiel:

- womo-power-measurement/status
- womo-power-measurement/sensor/.../state

Diese Legacy-Topics bestehen aktuell parallel zur neuen WoMo-Topic-Struktur.

## Messgrößen / Funktionen

- 12 × Strom RMS
- 12 × Wirkleistung
- 1 × Netzspannung RMS
- 1 × Netzfrequenz
- 1 × Gesamtwirkleistung

## Betriebsverhalten

- Messzyklus: 1 s
- MQTT Publish der Power-Daten: 1 s
- Health-Publishes: beim Boot und zyklisch
- OTA Update: aktiv

## Bekannte Risiken / Grenzen

- Wirkleistung aktuell noch Platzhalterwert 0.0 W pro Kanal
- Spannungsmessung aktuell noch nicht plausibel für 230 VAC
- ADC2 liefert derzeit unplausible Werte auf mehreren Kanälen
- Debug-Fokus bleibt: ADC2 / Referenz / Kanalzuordnung / Skalierung

## Teststatus

- [x] Kompiliert
- [x] OTA erfolgreich
- [x] MQTT verbunden
- [x] Systemtopics publizieren unter womo/system
- [x] Powertopics publizieren unter womo/power
- [ ] Sensordaten plausibel
- [ ] Wirkleistungsberechnung korrekt
- [ ] Langzeittest bestanden

## Verknüpfte Dokumente

- Standard: docs/standards/mqtt-topic-structure.md
- Standard: docs/standards/node-health-topics.md
- Architektur: docs/architecture/system-overview.md
- Runbook: knowledge/runbooks/ad7606-debug.md
