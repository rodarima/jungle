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

  # Only allow SSH connections from users who have a SLURM allocation
  # See: https://slurm.schedmd.com/pam_slurm_adopt.html
  security.pam.services.sshd.rules.account.slurm = {
    control = "required";
    enable = true;
    modulePath = "${pkgs.slurm}/lib/security/pam_slurm_adopt.so";
    args = [ "log_level=debug5" ];
    order = 999999; # Make it last one
  };

  # Disable systemd session (pam_systemd.so) as it will conflict with the
  # pam_slurm_adopt.so module. What happens is that the shell is first adopted
  # into the slurmstepd task and then into the systemd session, which is not
  # what we want, otherwise it will linger even if all jobs are gone.
  security.pam.services.sshd.startSession = lib.mkForce false;
}
