#!/bin/sh -e

if [ "$(id -u)" != 0 ]; then
 echo "Needs root permissions"
 exit 1
fi

host=$(hostname)
conf="$(readlink -f .)/${host}/configuration.nix"

if [ ! -e "$conf" ]; then
 echo "Missing config $conf"
 exit 1
fi

NIXOS_CONFIG="${conf}" nixos-rebuild switch
