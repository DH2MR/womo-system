#!/usr/bin/env bash
set -euo pipefail

BROKER="${BROKER:-10.10.64.10}"
PORT="${PORT:-1883}"
USER_NAME="${USER_NAME:-esphome}"
PASSWORD="${PASSWORD:-womo_mqtt_2026}"
FILTER="${1:-womo/#}"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing command: $1"; exit 1; }
}

require_cmd mosquitto_sub
require_cmd awk
require_cmd sort
require_cmd uniq
require_cmd grep

echo "Sampling topics from broker ${BROKER}:${PORT}"
echo "Filter: ${FILTER}"
echo ""

TMP=$(mktemp)

timeout 8s mosquitto_sub \
  -h "$BROKER" \
  -p "$PORT" \
  -u "$USER_NAME" \
  -P "$PASSWORD" \
  -t "$FILTER" \
  -v \
| awk '{print $1}' \
| sort -u > "$TMP"

echo "Found topics:"
cat "$TMP"
echo ""

echo "Validation results:"
echo "-------------------"

# allowed domains
DOMAINS="power water climate control system gateway debug"

while read -r topic; do
  domain=$(echo "$topic" | awk -F/ '{print $2}')

  if ! echo "$DOMAINS" | grep -qw "$domain"; then
    echo "WARN: unknown domain -> $topic"
    continue
  fi

  case "$domain" in
    system)
      if ! echo "$topic" | grep -Eq '^womo/system/[^/]+/(status|uptime|wifi_rssi|firmware|ip)$'; then
        echo "WARN: unusual system topic -> $topic"
      fi
      ;;
    control)
      if ! echo "$topic" | grep -Eq '^womo/control/[^/]+/(cmd|state|fault)$'; then
        echo "WARN: unusual control topic -> $topic"
      fi
      ;;
    power)
      if ! echo "$topic" | grep -Eq '^womo/power/[^/]+/.+'; then
        echo "WARN: unusual power topic -> $topic"
      fi
      ;;
    climate|water|gateway|debug)
      # basic structure check only
      if ! echo "$topic" | grep -Eq '^womo/'"$domain"'/[^/]+/.+'; then
        echo "WARN: malformed topic -> $topic"
      fi
      ;;
  esac

done < "$TMP"

echo ""
echo "Validation complete."

rm "$TMP"
