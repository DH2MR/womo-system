---
id: node.<node_name>
type: node
status: draft
owner: engineering
last_updated: YYYY-MM-DD
tags: []
relations:
  uses: []
  topics: []
---

# Node: <node_name>

## Zweck
Kurze Beschreibung der Aufgabe des Nodes im Gesamtsystem.

## Status
- Status: draft / testing / active / deprecated
- Standort:
- Verantwortlich:
- Letzte Änderung:

## Hardware

### Controller
- Board:
- MCU:
- Versorgung:

### Sensoren / ICs
- Bauteil:
- Funktion:
- Schnittstelle:

## Pinbelegung

| Signal | GPIO | Richtung | Beschreibung |
|---|---:|---|---|

## Firmware
- ESPHome Node Name:
- Friendly Name:
- YAML-Datei:
- Custom Component:

## Netzwerk
- WLAN:
- DHCP Reservation:
- MQTT Broker:
- Hostname:

## MQTT

### Publish Topics
| Topic | Payload | Beschreibung |
|---|---|---|

### Subscribe Topics
| Topic | Payload | Beschreibung |
|---|---|---|

## Messgrößen / Funktionen
- Messgröße 1
- Messgröße 2

## Kalibrierung
- Verfahren:
- Offsets:
- Skalierungsfaktoren:

## Betriebsverhalten
- Boot-Verhalten
- Update-Verhalten
- Fehlerverhalten

## Bekannte Risiken / Grenzen
- Punkt 1
- Punkt 2

## Teststatus
- [ ] Kompiliert
- [ ] OTA erfolgreich
- [ ] MQTT ok
- [ ] Sensordaten plausibel
- [ ] Langzeittest bestanden

## Verknüpfte Dokumente
- ADRs:
- Debugging:
- Runbooks:
- Schaltplan / PCB:
