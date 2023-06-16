#!/bin/sh -ex

if [ "$(id -u)" != 0 ]; then
 echo "Needs root permissions"
 exit 1
fi

if [ "$(hostname)" != "hut" ]; then
  >&2 echo "must run from machine hut, not $(hostname)"
  exit 1
fi

# Update all nodes
nixos-rebuild switch --flake .
nixos-rebuild switch --flake .#owl1 --target-host owl1
nixos-rebuild switch --flake .#owl2 --target-host owl2
