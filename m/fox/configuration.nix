{ lib, config, pkgs, ... }:

{
  imports = [
    ../common/base.nix
    ../common/xeon/console.nix
    ../module/amd-uprof.nix
    ../module/emulation.nix
    ../module/nvidia.nix
    ../module/slurm-client.nix
    ./wireguard.nix
  ];

  # Don't turn off on August as UPC has different dates.
  # Fox works fine on power cuts.
  systemd.timers.august-shutdown.enable = false;

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x500a07514b0c1103";

  # No swap, there is plenty of RAM
  swapDevices = lib.mkForce [];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" "amd_uncore" "amd_hsmp" ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.cpu.intel.updateMicrocode = lib.mkForce false;

  # Use performance for benchmarks
  powerManagement.cpuFreqGovernor = "performance";

  services.amd-uprof.enable = true;

  # Disable NUMA balancing
  boot.kernel.sysctl."kernel.numa_balancing" = 0;

  # Expose kernel addresses
  boot.kernel.sysctl."kernel.kptr_restrict" = 0;

  # Disable NMI watchdog to save one hw counter (for AMD uProf)
  boot.kernel.sysctl."kernel.nmi_watchdog" = 0;

  services.openssh.settings.X11Forwarding = true;

  services.fail2ban.enable = true;

  # Use SSH tunnel to reach internal hosts
  programs.ssh.extraConfig = ''
    Host bscpm04.bsc.es gitlab-internal.bsc.es tent
      ProxyJump raccoon
    Host raccoon
      ProxyJump apex
      HostName 127.0.0.1
      Port 22022
  '';

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

  # Recommended for new graphics cards
  hardware.nvidia.open = true;

  # Mount NVME disks
  fileSystems."/nvme0" = { device = "/dev/disk/by-label/nvme0"; fsType = "ext4"; };
  fileSystems."/nvme1" = { device = "/dev/disk/by-label/nvme1"; fsType = "ext4"; };

  # Mount the NFS home
  fileSystems."/nfs/home" = {
    device = "10.106.0.30:/home";
    fsType = "nfs";
    options = [ "nfsvers=3" "rsize=1024" "wsize=1024" "cto" "nofail" ];
  };

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
