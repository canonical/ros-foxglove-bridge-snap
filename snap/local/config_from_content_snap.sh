#!/bin/bash -e

CONFIGURATION_FILE_PATH=$SNAP_COMMON/configuration/foxglove-bridge.yaml

if [ ! -f "$CONFIGURATION_FILE_PATH" ]; then
  echo "Configuration file '$CONFIGURATION_FILE_PATH' does not exist."
  exit 1
fi

OPTIONS="port
address
tls
certfile
keyfile
topic-whitelist
param-whitelist
service-whitelist
client-topic-whitelist
min-qos-depth
max-qos-depth
num-threads
send-buffer-limit
use-sim-time
use-compression
capabilities
include-hidden
asset-uri-allowlist"

for OPTION in ${OPTIONS}; do
  VALUE="$(yq -e ".${OPTION}" $CONFIGURATION_FILE_PATH || true)"
  if [ "${VALUE}" != null ]; then
    snapctl set "${OPTION}"="${VALUE}"
  fi
done

$SNAP/usr/bin/validate_config.sh
