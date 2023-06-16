{ config, pkgs, modulesPath, lib, ... }:

{
  imports = [
    #(modulesPath + "/installer/netboot/netboot-minimal.nix")
    ../common/main.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d535629";
  #programs.ssh.forwardX11 = false;
  #programs.ssh.setXAuthLocation = lib.mkForce true;

  networking = {
    hostName = "owl2";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.2";
      prefixLength = 24;
    } ];
    interfaces.ibp129s0.ipv4.addresses = [ {
      address = "10.0.42.2";
      prefixLength = 24;
    } ];
  };
}
