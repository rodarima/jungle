{ config, pkgs, ... }:

{
  imports = [
    ../common/main.nix

    ./gitlab-runner.nix
    ./monitoring.nix
    ./nfs.nix
    ./slurm-daemon.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

  networking = {
    hostName = "xeon07";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.7";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.7";
      prefixLength = 24;
    } ];
  };
}
