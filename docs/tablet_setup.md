# WoMo Tablet Setup

## Ziel
Das Android-Tablet dient als festes Home-Assistant-Bedienpanel im WoMo.

## Verwendete Software
- Home Assistant
- Fully Kiosk Browser

## Home Assistant
- URL: `http://10.10.64.10:8123`
- Dashboard: `WoMo Tablet`
- Ansicht: `Licht`
- Aktuelle URL:
  - `http://10.10.64.10:8123/womo-tablet/licht`

## Fully Kiosk
Aktueller Stand:
- Launch on Boot: aktiviert
- Motion Detection: aktiviert
- Turn Screen On on Motion: aktiviert
- Start URL: WoMo Tablet / Licht
- Force Immersive Fullscreen: aktiviert

## Verhalten
- Tablet startet Fully automatisch
- Fully lädt direkt das WoMo-Tablet-Dashboard
- Dashboard läuft im Vollbild
- Android bleibt per Wischgeste weiterhin erreichbar
- Bildschirm wird per Bewegungserkennung aktiviert

## Hinweise
- Dieser Zustand ist bewusst so gewählt: Vollbild ja, aber kein kompletter Lockout.
- Änderungen an URL, Motion Detection oder Kiosk-Verhalten sollten hier nachgeführt werden.
