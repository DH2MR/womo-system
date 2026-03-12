# MQTT Topic Structure Standard

## Ziel

Dieser Standard definiert die verbindliche MQTT-Topic-Struktur im WoMo-System.

Ziele:

- konsistente Benennung aller Topics
- klare Trennung zwischen Systemdaten, Fachdaten, Commands und Events
- stabile Grundlage für Monitoring, Automatisierung und Agent-Systeme

---

# Namespace

Alle Topics beginnen mit:

womo/

---

# Topic-Klassen

## 1. System / Health

Format

womo/system/<node>/<metric>

Beispiele

womo/system/womo-power-measurement/status
womo/system/womo-power-measurement/uptime
womo/system/womo-power-measurement/wifi_rssi
womo/system/womo-power-measurement/ip
womo/system/womo-power-measurement/restart_reason
womo/system/womo-power-measurement/heap_free

---

## 2. Fachdaten

Format

womo/<domain>/<entity>/<metric>

oder

womo/<domain>/<entity>/<subentity>/<metric>

Beispiele

womo/climate/wohnraum/temperature
womo/climate/wohnraum/humidity
womo/climate/wohnraum/co2

womo/water/fresh/level
womo/water/fresh/volume

womo/power/ac/voltage
womo/power/ac/frequency
womo/power/channel/ch1/current
womo/power/channel/ch1/real_power
womo/power/total/real_power

---

## 3. Commands

Format

womo/cmd/<node>/<command>

oder

womo/cmd/<node>/<module>/<command>

Beispiele

womo/cmd/womo-climate-wohnraum/restart
womo/cmd/womo-power-measurement/calibrate

---

## 4. Events

Format

womo/event/<domain>/<entity>/<event>

Beispiele

womo/event/water/fresh/refilled

---

## 5. Alerts

Format

womo/alert/<domain>/<entity>/<alert>

Beispiele

womo/alert/climate/wohnraum/co2-high
womo/alert/power/channel/ch1/overcurrent

---

# Namensregeln

- nur Kleinbuchstaben
- Bindestriche als Trenner
- keine Leerzeichen
- keine Einheiten im Topicnamen

Beispiel korrekt

womo/climate/wohnraum/temperature

Beispiel falsch

womo/climate/Wohnraum/Temperature
womo/climate/wohnraum/temperature_celsius

---

# Payload-Regeln

Messwerte bevorzugt als primitive Werte veröffentlichen.

Beispiele

229.4
2.31
-67
online

JSON nur verwenden, wenn strukturierte Daten notwendig sind.

---

# QoS Empfehlungen

Systemzustände

QoS 1

Messwerte

QoS 0

status Topic

retained

---

# Bestehender Node Health Standard

Folgende Topics sind verpflichtend:

womo/system/<node>/status
womo/system/<node>/uptime
womo/system/<node>/wifi_rssi
womo/system/<node>/ip
womo/system/<node>/restart_reason
womo/system/<node>/heap_free
