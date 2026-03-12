#!/usr/bin/env bash

set -euo pipefail

BROKER="${BROKER:-10.10.64.10}"
PORT="${PORT:-1883}"
USER_NAME="${USER_NAME:-esphome}"
PASSWORD="${PASSWORD:-womo_mqtt_2026}"

MODE="${1:-topics}"
FILTER="${2:-womo/#}"

usage() {
  echo "Usage:"
  echo "  mqtt-inspect.sh topics [topic-filter]"
  echo "  mqtt-inspect.sh live   [topic-filter]"
  echo "  mqtt-inspect.sh tree   [topic-filter]"
  echo "  mqtt-inspect.sh count  [topic-filter]"
  echo ""
  echo "Examples:"
  echo "  mqtt-inspect.sh topics"
  echo "  mqtt-inspect.sh topics womo/system/#"
  echo "  mqtt-inspect.sh live womo/power/#"
  echo "  mqtt-inspect.sh tree womo/#"
  echo "  mqtt-inspect.sh count womo/#"
  exit 1
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Error: required command not found: $1"
    exit 1
  }
}

require_cmd mosquitto_sub
require_cmd awk
require_cmd sort
require_cmd uniq

case "$MODE" in
  topics)
    echo "Broker: ${BROKER}:${PORT}"
    echo "Mode: unique topics"
    echo "Filter: ${FILTER}"
    echo ""

    timeout 8s mosquitto_sub \
      -h "$BROKER" \
      -p "$PORT" \
      -u "$USER_NAME" \
      -P "$PASSWORD" \
      -t "$FILTER" \
      -v \
    | awk '{print $1}' \
    | sort -u
    ;;

  live)
    echo "Broker: ${BROKER}:${PORT}"
    echo "Mode: live stream"
    echo "Filter: ${FILTER}"
    echo "Press Ctrl+C to stop."
    echo ""

    mosquitto_sub \
      -h "$BROKER" \
      -p "$PORT" \
      -u "$USER_NAME" \
      -P "$PASSWORD" \
      -t "$FILTER" \
      -v
    ;;

  tree)
    echo "Broker: ${BROKER}:${PORT}"
    echo "Mode: topic tree"
    echo "Filter: ${FILTER}"
    echo ""

    timeout 8s mosquitto_sub \
      -h "$BROKER" \
      -p "$PORT" \
      -u "$USER_NAME" \
      -P "$PASSWORD" \
      -t "$FILTER" \
      -v \
    | awk '{print $1}' \
    | sort -u \
    | awk -F/ '
      {
        indent=""
        for (i=1; i<=NF; i++) {
          key=""
          for (j=1; j<=i; j++) {
            key = key (j==1 ? "" : "/") $j
          }
          if (!(key in seen)) {
            for (k=1; k<i; k++) indent=indent"  "
            print indent "- " $i
            indent=""
            seen[key]=1
          }
        }
      }
    '
    ;;

  count)
    echo "Broker: ${BROKER}:${PORT}"
    echo "Mode: topic frequency sample"
    echo "Filter: ${FILTER}"
    echo ""

    timeout 8s mosquitto_sub \
      -h "$BROKER" \
      -p "$PORT" \
      -u "$USER_NAME" \
      -P "$PASSWORD" \
      -t "$FILTER" \
      -v \
    | awk '{print $1}' \
    | sort \
    | uniq -c \
    | sort -nr
    ;;

  *)
    usage
    ;;
esac
