# 🚐 WoMo ESPHome Firmware

Dieses Repository enthält die ESPHome-Konfiguration für das Wohnmobil (WoMo).

Ziel ist eine **modulare, wiederverwendbare Architektur** für alle Nodes (Licht, Sensorik, etc.).

---

## 🧱 Projektstruktur

```
firmware/esphome/
├── base/          # Basis-Module (Pflicht für alle Nodes)
├── common/        # Wiederverwendbare Funktionsbausteine
├── sensors/       # Sensor-spezifische Module
├── components/    # Custom ESPHome Komponenten (C++)
├── *.yaml         # Geräte-spezifische Nodes
```

---

## ⚙️ Architekturprinzip

Alle Geräte bestehen aus:

* **device_base.yaml**
  → Grundkonfiguration (ESP32, WLAN, MQTT, OTA)

* **node_health.yaml**
  → Status- und Diagnosewerte (MQTT, Uptime, RSSI, Heap, IP)

* **Funktionsmodulen**
  → z. B. Licht, Sensoren, Aktoren

Ein Gerät bindet diese über `packages` ein.

---

## 💡 Licht-Node (CCT)

### Hardware

* ESP32-S3 Zero
* 24V CCT LED Stripe (CW / WW)
* MOSFET Low-Side Schaltung

### PWM

* Frequenz: **244 Hz**
* Kein sichtbares Flackern

### Dimmlogik

* Kennlinie:

  ```
  out = pow(in, curve)
  ```
* Standard:

  ```
  curve = 1.10
  ```

### Verhalten

* Kein Flackern
* Kein „Parken“ beim Ausschalten
* Unterer Bereich fein dimmbar

### Ausschalten (wichtig)

```yaml
on_turn_off:
  - output.set_level:
      id: pwm_cw
      level: 0%
  - output.set_level:
      id: pwm_ww
      level: 0%
```

---

## 🌐 Netzwerk

* DHCP (keine statische IP im Code)
* Empfehlung: DHCP-Reservierung im Router

---

## 📡 MQTT Struktur

Status:

```
womo/system/<node>/status
```

Health:

```
womo/system/<node>/ip
womo/system/<node>/uptime
womo/system/<node>/wifi_rssi
womo/system/<node>/heap_free
```

Debug:

```
womo/debug/<node>
```

---

## 🔄 Geräte hinzufügen

Neues Gerät erstellen:

1. Neue YAML Datei anlegen:

   ```
   bad-deckenlicht.yaml
   ```

2. Substitutions definieren:

   ```yaml
   substitutions:
     name: bad-deckenlicht
     friendly_name: Bad Deckenlicht
   ```

3. Packages einbinden:

   ```yaml
   packages:
     device_base: !include base/device_base.yaml
     node_health: !include base/node_health.yaml
     light_node: !include base/light_node_cct.yaml
   ```

---

## 🧠 Ziel

* Einheitliche Firmware für alle Nodes
* Minimale Geräte-spezifische Konfiguration
* Maximale Wiederverwendbarkeit
* Einfache Erweiterbarkeit

---

## 🔜 TODO / Erweiterungen

* Tastersteuerung
* Szenen / Presets
* Nachtmodus
* Helligkeitsbegrenzung
* Präsenz-/Türsensor-Integration

---

## 👨‍🔧 Hinweis

Diese Struktur ist speziell für das WoMo optimiert:

* stabil
* nachvollziehbar
* wartbar auch nach längerer Zeit

---

**Stand:** Licht-Node vollständig funktionsfähig und als Basis implementiert
