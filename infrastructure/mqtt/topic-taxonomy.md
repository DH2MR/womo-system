# WoMo MQTT Topic Taxonomy

## Root

womo/

## Domains

womo/power
womo/water
womo/climate
womo/control
womo/system
womo/gateway
womo/debug

## Node Status

womo/system/<node>/status
womo/system/<node>/uptime
womo/system/<node>/wifi_rssi

## Sensor Nodes

womo/climate/<location>/<metric>

## Power Nodes

womo/power/<device>/<channel>/<metric>

## Control Nodes

womo/control/<device>/cmd
womo/control/<device>/state

## Water System

womo/water/<tank>/<metric>

## Debug

womo/debug/<node>/<message>

