# WoMo System – MQTT Konzept

## 1. Ziel

Diese Dokumentation definiert:

* einheitliche Topic-Struktur
* Namenskonventionen
* Trennung von State / Command
* Grundlage für Steuerung (Licht, Relais, Sensoren)

---

## 2. Grundprinzip

MQTT dient als zentrale Kommunikationsschicht:

```text
ESP Node → MQTT → Home Assistant → Tablet
Tablet → Home Assistant → MQTT → ESP Node
```

---

## 3. Topic-Struktur (Standard)

### Basis-Schema

```text
womo/<node>/<type>/<entity>/<direction>
```

---

## 4. Topic-Typen

### 4.1 Sensoren

```text
womo/<node>/sensor/<name>/state
```

Beispiel:

```text
womo/power_bank_a/sensor/voltage/state
womo/power_bank_a/sensor/current_l1/state
```

---

### 4.2 Schalter / Relais

```text
womo/<node>/switch/<name>/state
womo/<node>/switch/<name>/command
```

Beispiel:

```text
womo/keller/switch/light/state
womo/keller/switch/light/command
```

---

### 4.3 Status

```text
womo/system/<node>/status
```

Werte:

* `online`
* `offline`

---

### 4.4 Debug

```text
womo/debug/<node>
```

---

## 5. State vs Command (sehr wichtig)

### State (vom ESP → MQTT)

```text
.../state
```

* aktueller Zustand
* wird vom ESP gesendet

---

### Command (von HA → ESP)

```text
.../command
```

* Steuerbefehl
* wird vom ESP empfangen

---

### Beispiel (Relais)

```text
HA → womo/keller/switch/light/command → "ON"
ESP → womo/keller/switch/light/state → "ON"
```

---

## 6. Naming-Konventionen

### Nodes

```text
womo_<bereich>_<funktion>
```

Beispiele:

* `womo_keller_light`
* `womo_power_bank_a`
* `womo_wohnraum_env`

---

### Entities

* lowercase
* snake_case
* sprechend

Beispiele:

```text
light
pump
heater
voltage
current_l1
temperature
```

---

## 7. Payload-Standards

### Schalter

```text
ON
OFF
```

---

### Sensoren

* numerisch (Float / Integer)
* keine Einheiten im Payload

Beispiel:

```text
23.5
```

Einheit kommt in HA, nicht im MQTT

---

## 8. Retain-Strategie

| Topic-Typ | Retain |
| --------- | ------ |
| state     | ✅ ja   |
| command   | ❌ nein |
| status    | ✅ ja   |

---

## 9. QoS-Empfehlung

| Anwendung | QoS |
| --------- | --- |
| Status    | 1   |
| Steuerung | 1   |
| Sensoren  | 0–1 |

---

## 10. Home Assistant Integration

### Variante A (aktuell bei dir)

* manuelle Nutzung der Topics
* oder einfache Entities

### Variante B (empfohlen später)

→ MQTT Discovery

---

## 11. MQTT Discovery (optional)

Beispiel für Switch:

```json
{
  "name": "Keller Licht",
  "state_topic": "womo/keller/switch/light/state",
  "command_topic": "womo/keller/switch/light/command",
  "payload_on": "ON",
  "payload_off": "OFF",
  "unique_id": "womo_keller_light"
}
```

---

## 12. Best Practices

### ✅ Do

* klare Struktur (node/type/entity)
* State & Command trennen
* einheitliche Namen
* Retain für State nutzen

---

### ❌ Don't

* gemischte Topics
* Einheiten im Payload
* mehrere Bedeutungen in einem Topic
* direkte Hardwarelogik im MQTT

---

## 13. Beispiel Gesamtfluss

```text
Tablet klickt „Licht an“

→ HA sendet:
womo/keller/switch/light/command = ON

→ ESP schaltet Relais

→ ESP sendet:
womo/keller/switch/light/state = ON

→ HA aktualisiert UI
```

---

## 14. Erweiterung (zukünftig)

* Dimmer:

```text
.../light/<name>/brightness
```

* Szenen:

```text
womo/system/scene/<name>/command
```

---

## 15. Zielbild

Ein konsistentes System, bei dem:

* jedes Gerät eindeutig identifizierbar ist
* Steuerung und Status sauber getrennt sind
* Erweiterungen ohne Chaos möglich sind

---

