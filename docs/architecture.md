# WoMo System – Architektur

## 1. Überblick

Das WoMo-System basiert auf einer **zentralen Steuerung über Home Assistant** und einer **MQTT-basierten Kommunikation mit ESPHome-Nodes**.

Ziel:

* klare Trennung von Logik, Kommunikation und Hardware
* modular erweiterbares System
* stabile Offline-Funktion im Fahrzeug

---

## 2. Systemarchitektur

```text
┌──────────────────────────────┐
│        Tablet / UI           │
│  (Home Assistant App)        │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│      Home Assistant          │
│      Port: 8123              │
│  - Dashboard / UI            │
│  - Automationen              │
└──────────────┬───────────────┘
               │ MQTT
               ▼
┌──────────────────────────────┐
│     MQTT Broker              │
│     (Mosquitto)              │
│     Port: 1883               │
└──────────────┬───────────────┘
               │
     ┌─────────┴─────────┐
     ▼                   ▼
┌──────────────┐  ┌──────────────┐
│ ESP Node A   │  │ ESP Node B   │
│ (Sensoren)   │  │ (Relais)     │
└──────────────┘  └──────────────┘
       │                    │
       ▼                    ▼
 Sensoren             Aktoren (Relais, Licht)
```

---

## 3. Kommunikationsmodell

### MQTT als zentrale Datenebene

Alle ESP-Nodes kommunizieren über MQTT:

* Telemetrie (Sensorwerte)
* Statusmeldungen
* Steuerbefehle

### Beispiel Datenfluss

```text
Tablet → Home Assistant → MQTT → ESP Node → Relais
ESP Node → MQTT → Home Assistant → Tablet
```

---

## 4. Topic-Struktur (aktuelles Schema)

Basierend auf deinem `device_base.yaml`:

```text
womo/system/<node>/status
womo/debug/<node>
```

### Empfehlung für Erweiterung (zukünftig)

```text
womo/<node>/sensor/<name>
womo/<node>/switch/<name>/state
womo/<node>/switch/<name>/command
```

---

## 5. Node-Architektur (ESPHome)

Jeder Node basiert auf einer modularen Struktur:

```text
packages:
  base:        device_base.yaml
  node_health: node_health.yaml
  diag:        diag_basic.yaml
  sensors:     z. B. ad7606_dual_power.yaml
```

### Basis (`device_base.yaml`)

* WLAN
* MQTT
* OTA
* Logging

### Erweiterungen

* Sensoren (z. B. AD7606)
* später: Relais / Licht

---

## 6. Rollen der Komponenten

| Komponente     | Aufgabe                 |
| -------------- | ----------------------- |
| Home Assistant | UI, Logik, Automationen |
| MQTT Broker    | Kommunikation           |
| ESPHome        | Firmware & Build        |
| ESP Nodes      | Hardwaresteuerung       |

---

## 7. Betriebsmodi

### Aktuell (Produktiv)

* MQTT-basierte Kommunikation
* keine direkte ESPHome API Nutzung

### Optional (zukünftig)

* Hybridbetrieb mit `api:` möglich
* direkte Integration in Home Assistant

---

## 8. Vorteile der aktuellen Architektur

* lose Kopplung der Komponenten
* stabil auch ohne Internet
* leicht erweiterbar
* gut für Fahrzeugbetrieb geeignet

---

## 9. Erweiterungspunkte

### Kurzfristig

* Licht-/Relais-Nodes
* Tablet Dashboard

### Mittelfristig

* saubere MQTT Topic-Struktur
* State/Command Trennung

### Langfristig

* Automatisierung (Agenten / MCP)
* Energie-Management
* Laststeuerung

---

## 10. Designprinzipien

* klare Trennung von:

  * Hardware (ESP)
  * Kommunikation (MQTT)
  * Logik (Home Assistant)

* Wiederverwendbarkeit durch Packages

* keine „Hardcodierung“ in einzelnen Nodes

---

## 11. Bekannte Einschränkungen

* keine direkte Geräteerkennung in HA (ohne API)
* MQTT erfordert saubere Topic-Disziplin
* Debugging über mehrere Ebenen notwendig

---

## 12. Zukunftsoption: ESPHome API

Optional kann folgende Erweiterung erfolgen:

```yaml
api:
```

Vorteile:

* automatische Geräteerkennung in HA
* weniger manuelle MQTT-Konfiguration

Nachteil:

* stärkere Kopplung an Home Assistant

---
