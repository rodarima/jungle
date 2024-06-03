{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/base.nix
  ];

  # Don't install Grub on the disk yet
  boot.loader.grub.device = "nodev";

  networking = {
    hostName = "raccoon";
    # Only BSC DNSs seem to be reachable from the office VLAN
    nameservers = [ "84.88.52.35" "84.88.52.36" ];
    defaultGateway = "84.88.51.129";
    interfaces.eno0.ipv4.addresses = [ {
      address = "84.88.51.152";
      prefixLength = 25;
    } ];
  };

  # Configure Nvidia driver to use with CUDA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    setLdLibraryPath = true;
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
