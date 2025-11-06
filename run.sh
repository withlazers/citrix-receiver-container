#!/bin/bash -x
set -x

PULSE_AUDIO_BRIDGE_INDEX=""
PULSE_SERVER_FOR_DOCKER="${PULSE_SERVER_FOR_DOCKER:-$PULSE_SERVER}"
if [[ -z "${PULSE_SERVER_FOR_DOCKER}" ]]; then
  # cat /proc/sys/net/ipv4/ip_local_port_range
  PULSE_AUDIO_BRIDGE_PORT="${PULSE_AUDIO_BRIDGE_PORT:-53971}"
  LANG=c PULSE_AUDIO_BRIDGE_INDEX="$(pactl load-module module-native-protocol-tcp port=$PULSE_AUDIO_BRIDGE_PORT auth-ip-acl=127.0.0.1)"
  PULSE_SERVER_FOR_DOCKER="tcp:127.0.0.1:$PULSE_AUDIO_BRIDGE_PORT"
fi

podman run --rm \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 \
  -v $XAUTHORITY:/xauth \
  -e XAUTHORITY=/xauth \
  --ipc=host \
  --hostname citrix-receiver-container \
  --name citrix \
  -e TZ="Europe/Berlin" \
  --net=host \
  -e PULSE_SERVER=$PULSE_SERVER_FOR_DOCKER \
  -e USE_FIREFOX_FOR_SELFSERVICE \
  citrix "$@"

if ! [[ -z "${PULSE_AUDIO_BRIDGE_INDEX}" ]]; then
  pactl unload-module $PULSE_AUDIO_BRIDGE_INDEX
fi
