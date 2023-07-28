{ config, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
    ../common/main.nix
  ];

  services.openssh.settings.X11Forwarding = false;
  nixpkgs.config.allowBroken = true;

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53562d";

  networking = {
    hostName = "bay";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.40";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.40";
      prefixLength = 24;
    } ];
  };
}
