{ config, pkgs, ... }:

{
  imports = [
    ../common/main.nix

    ../module/ceph.nix
    ./gitlab-runner.nix
    ./monitoring.nix
    ./nfs.nix
    ./slurm-daemon.nix
    #./pxe.nix
  ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" "powerpc64le-linux" "riscv64-linux" ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

  networking = {
    hostName = "hut";
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
