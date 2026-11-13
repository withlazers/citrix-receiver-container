#!/bin/bash -x
set -x

PULSE_AUDIO_BRIDGE_INDEX=""
PULSE_SERVER_FOR_DOCKER="${PULSE_SERVER_FOR_DOCKER:-$PULSE_SERVER}"
if [[ -z "${PULSE_SERVER_FOR_DOCKER}" ]]; then
  # cat /proc/sys/net/ipv4/ip_local_port_range
  PULSE_AUDIO_BRIDGE_PORT="${PULSE_AUDIO_BRIDGE_PORT:-53971}"
  # Reuse the bridge a previous run left loaded.
  PULSE_AUDIO_BRIDGE_INDEX="$(LANG=c pactl list short modules | awk -v p="port=$PULSE_AUDIO_BRIDGE_PORT" '$2 == "module-native-protocol-tcp" && index($0, p) { print $1 }')"
  [[ -n "$PULSE_AUDIO_BRIDGE_INDEX" ]] || PULSE_AUDIO_BRIDGE_INDEX="$(LANG=c pactl load-module module-native-protocol-tcp port=$PULSE_AUDIO_BRIDGE_PORT auth-ip-acl=127.0.0.1)"
  PULSE_SERVER_FOR_DOCKER="tcp:127.0.0.1:$PULSE_AUDIO_BRIDGE_PORT"
fi

# selfservice keeps running after its window closes; --replace ends that leftover.
# The WEBKIT/LIBGL vars are needed because there is no /dev/dri; without them no window appears.
podman run --rm --replace \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix/X0:/tmp/.X11-unix/X0 \
  -v $XAUTHORITY:/xauth \
  -e XAUTHORITY=/xauth \
  -v citrix-ica:/root/.ICAClient \
  -e WEBKIT_DISABLE_DMABUF_RENDERER=1 \
  -e WEBKIT_DISABLE_COMPOSITING_MODE=1 \
  -e LIBGL_ALWAYS_SOFTWARE=1 \
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
