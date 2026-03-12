# Node Health Topics Standard

Jeder WoMo-Node publiziert standardisierte System- und Health-Daten über MQTT.

## Pflicht-Topics

womo/system/<node>/status
womo/system/<node>/uptime
womo/system/<node>/wifi_rssi
womo/system/<node>/ip
womo/system/<node>/restart_reason
womo/system/<node>/heap_free

## Ziel

- Monitoring aller Nodes
- einfaches Debugging
- konsistente Agent-Auswertung
- schnelle Erkennung von WLAN- oder Stabilitätsproblemen

## Semantik

### status
Werte:
- online
- offline

### uptime
Laufzeit des Nodes seit letztem Boot.

### wifi_rssi
WLAN-Signalstärke in dBm.

### ip
Aktuelle IP-Adresse des Nodes.

### restart_reason
Vom Controller gemeldeter Neustartgrund.

### heap_free
Freier Heap-Speicher.

## Empfehlungen

- status retained
- system state QoS 1
- Messwerte QoS 0
- last_seen optional ergänzen
