#!/bin/sh -x

######################################################################
# @author      : Enno Boland (mail@eboland.de)
# @file        : entrypoint
# @created     : Tuesday Jan 11, 2022 09:58:33 CET
#
# @description : Entrypoint for the docker container
######################################################################

#exec dbus-run-session -- firefox "$url" "$@"
exec firefox --no-remote "$@"
