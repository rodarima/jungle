{ lib, ... }:

{
  imports = [
    ../common/ssf.nix
    ../module/hut-substituter.nix
  ];

  # Select this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d5356ca";

  # No swap, there is plenty of RAM
  swapDevices = lib.mkForce [];

  # Users with sudo access
  users.groups.wheel.members = [ "abonerib" "anavarro" ];

  # Run julia installed with juliaup using julia's own libraries:
  # NIX_LD_LIBRARY_PATH=~/.julia/juliaup/${VERS}/lib/julia ~/.juliaup/bin/julia
  programs.nix-ld.enable = true;

  networking = {
    hostName = "weasel";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.6";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.6";
      prefixLength = 24;
    } ];
  };
}
