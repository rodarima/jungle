{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./fs.nix
  ];
}
