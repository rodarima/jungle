# Jungle

This repository provides two components that can be used independently:

- A Nix overlay with packages used at BSC (formerly known as bscpkgs). Access
  them directly with `nix shell .#<pkgname>`.

- NixOS configurations for jungle machines. Use `nixos-rebuild switch --flake .`
  to upgrade the current machine.
