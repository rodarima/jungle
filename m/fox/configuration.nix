{ lib, config, pkgs, ... }:

{
  imports = [
    ../common/base.nix
    ../common/xeon/console.nix
    ../module/emulation.nix
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500a07514b0c1103";

  # No swap, there is plenty of RAM
  swapDevices = lib.mkForce [];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" "amd_uncore" ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkForce false;

  # Use performance for benchmarks
  powerManagement.cpuFreqGovernor = "performance";

  services.openssh.settings.X11Forwarding = true;

  networking = {
    timeServers = [ "ntp1.upc.edu" "ntp2.upc.edu" ];
    hostName = "fox";
    # UPC network (may change over time, use DHCP)
    # Public IP configuration:
    # - Hostname: fox.ac.upc.edu
    # - IP: 147.83.30.141
    # - Gateway: 147.83.30.130
    # - NetMask: 255.255.255.192
    # Private IP configuration for BMC:
    # - Hostname: fox-ipmi.ac.upc.edu
    # - IP: 147.83.35.27
    # - Gateway: 147.83.35.2
    # - NetMask: 255.255.255.0
    interfaces.enp1s0f0np0.useDHCP = true;
  };

  # Use hut for cache
  nix.settings = {
    extra-substituters = [ "https://jungle.bsc.es/cache" ];
    extra-trusted-public-keys = [ "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" ];
  };

  # Configure Nvidia driver to use with CUDA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  hardware.graphics.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Mount NVME disks
  fileSystems."/nvme0" = { device = "/dev/disk/by-label/nvme0"; fsType = "ext4"; };
  fileSystems."/nvme1" = { device = "/dev/disk/by-label/nvme1"; fsType = "ext4"; };

  # Make a /nvme{0,1}/$USER directory for each user.
  systemd.services.create-nvme-dirs = let
    # Take only normal users in fox
    users = lib.filterAttrs (_: v: v.isNormalUser) config.users.users;
    commands = lib.concatLists (lib.mapAttrsToList
      (_: user: [
        "install -d -o ${user.name} -g ${user.group} -m 0755 /nvme{0,1}/${user.name}"
      ]) users);
    script = pkgs.writeShellScript "create-nvme-dirs.sh" (lib.concatLines commands);
  in {
    enable = true;
    wants = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = script;
  };
}
