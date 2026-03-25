# WoMo System – Zugriff & Übersicht

## 1. Systemübersicht

Zentrale Komponenten:

* **Raspberry Pi 5**

  * Betriebssystem: Ubuntu
  * Dienste: Docker

* **Docker Services**

  * Home Assistant (UI / Steuerung)
  * MQTT Broker (Mosquitto)
  * ESPHome (Firmware & Management)

* **ESP Nodes**

  * ESP32-S3 Zero
  * Kommunikation über MQTT

---

## 2. Netzwerk

* **IP Bereich:** 10.10.64.x

* **WLAN:**

  * 2.4 GHz: `womo_2G` (für ESPs)
  * 5 GHz: `womo_5G` (optional für Clients)

* **Zentrale IP:**

  * Raspberry Pi: `10.10.64.10`

---

## 3. Zugriffsdaten

### 3.1 Home Assistant

* URL:

  * http://10.10.64.10:8123

* Funktion:

  * Zentrale Steuerung
  * Dashboard / Tablet UI
  * Automationen

---

### 3.2 MQTT Broker (Mosquitto)

* Host: `10.10.64.10`

* Port: `1883`

* Benutzer: `esphome`

* Passwort: `womo_mqtt_2026`

* Verwendung:

  * Kommunikation zwischen ESP Nodes und Home Assistant

---

### 3.3 ESPHome Dashboard

* URL:

  * http://10.10.64.10:6052

* Funktion:

  * Firmware bauen
  * Nodes verwalten
  * Logs einsehen

---

### 3.4 Raspberry Pi (SSH)

* Host: `10.10.64.10`
* Zugriff:

```bash
ssh manuel@10.10.64.10
```

* Projektpfad:

```bash
~/projects/womo-system
```

---

## 4. Verzeichnisstruktur

```text
~/projects/womo-system/
├── firmware/
│   └── esphome/
│       ├── base/
│       ├── common/
│       ├── sensors/
│       ├── components/
│       └── *.yaml
│
├── stack/
│   ├── homeassistant/
│   ├── mosquitto/
│   └── esphome/
│
└── docs/
```

---

## 5. Architektur

```text
Tablet / UI
        ↓
Home Assistant (8123)
        ↓
MQTT Broker (1883)
        ↓
ESP32 Nodes (ESPHome)
        ↓
Relais / Sensoren / Aktoren
```

---

## 6. Wichtige Ports

| Dienst         | Port |
| -------------- | ---- |
| Home Assistant | 8123 |
| MQTT           | 1883 |
| ESPHome UI     | 6052 |
| ESP API        | 6053 |

---

## 7. Wichtige Hinweise

* ESPHome nutzt aktuell **MQTT (kein API)**
* Home Assistant kommuniziert über MQTT mit den Nodes
* Tablet ist nur ein **Frontend**, keine Logik
* IP-Adressen werden per **DHCP Reservation** vergeben

---

## 8. Typische Befehle

### Docker Status

```bash
docker ps
```

### Logs anzeigen

```bash
docker compose logs -f
```

### Home Assistant neu starten

```bash
cd ~/projects/womo-system/stack/homeassistant
docker compose restart
```

---

## 9. Nächste Schritte (Roadmap)

* MQTT Entities sauber strukturieren
* erster Licht-/Relais-Node
* Tablet Dashboard aufbauen
* Automationen definieren
* später optional: ESPHome API ergänzen

---
