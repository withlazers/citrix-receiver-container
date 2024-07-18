#!/bin/sh -x

######################################################################
# @author      : Enno Boland (mail@eboland.de)
# @file        : entrypoint
# @created     : Tuesday Jan 11, 2022 09:58:33 CET
#
# @description : Entrypoint for the docker container
######################################################################

#exec dbus-run-session -- firefox "$url" "$@"
export XAUTHORITY=/xauth

firefox --no-remote -CreateProfile 'User /profile'

cp /prefs.js /profile/prefs.js

exec firefox --no-remote --profile /profile "$@"
