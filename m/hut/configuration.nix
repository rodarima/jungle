{ config, pkgs, ... }:

{
  imports = [
    ../common/xeon.nix

    ../module/ceph.nix
    ../module/debuginfod.nix
    ../module/emulation.nix
    ../module/slurm-client.nix
    ./gitlab-runner.nix
    ./monitoring.nix
    ./nfs.nix
    ./slurm-server.nix
    ./nix-serve.nix
    ./public-inbox.nix
    ./gitea.nix
    ./msmtp.nix
    ./postgresql.nix
    ./nginx.nix
    #./pxe.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

  fileSystems."/nvme" = {
    fsType = "ext4";
    device = "/dev/disk/by-label/nvme";
  };

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
    firewall = {
      extraCommands = ''
        # Accept all proxy traffic from compute nodes but not the login
        iptables -A nixos-fw -p tcp -s 10.0.40.30 --dport 23080 -j nixos-fw-log-refuse
        iptables -A nixos-fw -p tcp -s 10.0.40.0/24 --dport 23080 -j nixos-fw-accept
      '';
    };
  };

  # Allow proxy to bind to the ethernet interface
  services.openssh.settings.GatewayPorts = "clientspecified";
}
