# WoMo System Architecture

## Überblick

Das WoMo-System ist eine modulare Fahrzeug-Automationsplattform.

Hauptkomponenten:

Nodes:
ESP32-S3 basierte Sensor- und Funktionsnodes.

Backend:
Raspberry Pi 5 mit Docker.

Kommunikation:
MQTT als zentrales Nachrichtenprotokoll.

## Backend

Hardware:
Raspberry Pi 5

OS:
Ubuntu

Services:

Mosquitto MQTT Broker  
ESPHome  
zukünftig: Agent / MCP / MCA / MPA

## Netzwerk

MQTT Broker:
10.10.64.10:1883

WLAN:
womo_2G
womo_5G

ESP-Nodes nutzen ausschließlich 2.4GHz.

IP-Zuweisung:
DHCP Reservation im Router.

## Node-Plattform

Standardboard:
ESP32-S3 Zero

Firmware:
ESPHome

Custom Components:
für spezielle Sensorik und Messaufgaben.
