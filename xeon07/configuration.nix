{ config, pkgs, ... }:

{
  imports = [
    ../common/main.nix

    ./gitlab-runner.nix
    ./monitoring.nix
    ./net.nix
    ./nfs.nix
    ./slurm.nix

    <agenix/modules/age.nix>
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

  environment.systemPackages = with pkgs; [
    (pkgs.callPackage <agenix/pkgs/agenix.nix> {})
  ];
}
