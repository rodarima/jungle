{ lib, config, pkgs, ... }:

{
  imports = [
    ../common/xeon.nix
    ../module/ceph.nix
    ../module/emulation.nix
    ../module/slurm-client.nix
    ../module/slurm-firewall.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500a07514b0c1103";

  # No swap, there is plenty of RAM
  swapDevices = lib.mkForce [];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkForce false;

  networking = {
    hostName = "fox";
    interfaces.enp1s0f0np0.ipv4.addresses = [ {
      address = "10.0.40.26";
      prefixLength = 24;
    } ];
  };

  # Configure Nvidia driver to use with CUDA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
