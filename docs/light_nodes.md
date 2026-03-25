# WoMo System – Licht Nodes (CCT)

## 1. Überblick

Licht-Nodes basieren auf einem **CCT-Design (Warmweiß/Kaltweiß)**.

Standard-Hardware-Zuordnung:

* Warmweiß → GPIO3
* Kaltweiß → GPIO2

---

## 2. Architektur

Ein Licht-Node besteht aus:

* Base-Konfiguration (`device_base.yaml`)
* Diagnose & Health
* Licht-Modul (`actuators/light_cct.yaml`)

---

## 3. MQTT Steuerung

### Command

```text
womo/<node>/light/<name>/command
```

Payload (JSON):

```json
{"state":"ON","brightness":255}
```

---

### State

```text
womo/<node>/light/<name>/state
```

---

## 4. Beispiel

Node:

```text
womo-light-keller
```

Topics:

```text
womo/womo-light-keller/light/keller_licht/command
womo/womo-light-keller/light/keller_licht/state
```

---

## 5. Besonderheiten

* MQTT erwartet JSON (kein simples ON/OFF)
* PWM-Ausgänge über LEDC
* geeignet für LED-Treiber / MOSFET

---

## 6. Erweiterung

Weitere Licht-Nodes nutzen dasselbe Modul:

* womo-light-wohnraum
* womo-light-aussen
* womo-light-bad

---

## 7. Designentscheidung

CCT wurde gewählt, weil:

* flexible Farbtemperatur
* einheitliche Hardwarebasis
* gute Integration in Home Assistant

---
