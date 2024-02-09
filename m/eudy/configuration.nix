{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ../common/main.nix
    #(modulesPath + "/installer/netboot/netboot-minimal.nix")

    ./kernel/kernel.nix
    ./cpufreq.nix
    ./fs.nix
    ./users.nix
    ../module/debuginfod.nix
  ];

  # Select this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x55cd2e414d53564b";

  # disable automatic garbage collector
  nix.gc.automatic = lib.mkForce false;

  # members of the tracing group can use the lttng-provided kernel events
  # without root permissions
  users.groups.tracing.members = [ "arocanon" ];

  # set up both ethernet and infiniband ips
  networking = {
    hostName = "eudy";
    interfaces.eno1.ipv4.addresses = [ {
      address = "10.0.40.8";
      prefixLength = 24;
    } ];
    interfaces.ibp5s0.ipv4.addresses = [ {
      address = "10.0.42.8";
      prefixLength = 24;
    } ];
  };
}
