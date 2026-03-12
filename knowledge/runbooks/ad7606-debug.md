# AD7606 Debugging Runbook

Typische Probleme bei AD7606 Integration.

## Symptome

ADC liefert nur Nullen.

## Prüfpunkte

1. Versorgung prüfen
2. CONVST Signal prüfen
3. BUSY Verhalten prüfen
4. SPI Clock prüfen
5. Chip Select prüfen

## Typische Ursachen

- falsche SPI Mode Konfiguration
- CONVST Timing
- BUSY Pin nicht korrekt ausgewertet
- Reset Sequenz fehlt

## Messmethoden

Oszilloskop
Logic Analyzer
Serielle Debug-Ausgaben

## Firmware Debug

ESPHome Logger aktivieren.
