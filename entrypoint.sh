#!/bin/bash -x

######################################################################
# @author      : Enno Boland (mail@eboland.de)
# @file        : entrypoint
# @created     : Tuesday Jan 11, 2022 09:58:33 CET
#
# @description : Entrypoint for the docker container
######################################################################

#exec dbus-run-session -- firefox "$url" "$@"
export XAUTHORITY=/xauth

mkdir -p /root/.ICAClient/
touch /root/.ICAClient/.eula_accepted
# Stale sockets from the previous run in the persistent volume leave the webview white.
find /root/.ICAClient -type s -delete
rm -rf /root/.ICAClient/.tmp

if ! [[ -z "${USE_FIREFOX_FOR_SELFSERVICE}" ]]; then
    mkdir -p /root/Downloads
    rm /root/Downloads/*.ica 2> /dev/null || true

    exec firefox --no-remote --profile /root/firefox-profile "$@"
else
    exec /opt/Citrix/ICAClient/selfservice
fi