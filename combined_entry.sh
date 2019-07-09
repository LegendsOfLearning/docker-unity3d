#!/bin/sh
export HOSTUID=${HOSTUID:=$(stat -c "%u" .)}
export HOSTGID=${HOSTGID:=$(stat -c "%g" .)}

exec /run-as-hostuid.sh /write_license_file.sh "$@"
