{ lib, pkgs, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;

  # Enable GRUB2 serial console
  boot.loader.grub.extraConfig = ''
    serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
    terminal_input --append serial
    terminal_output --append serial
  '';

  # Enable serial console
  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];

  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = lib.mkDefault "-1";

    # Allow ptracing (i.e. attach with GDB) any process of the same user, see:
    # https://www.kernel.org/doc/Documentation/security/Yama.txt
    "kernel.yama.ptrace_scope" = "0";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  #boot.kernelPatches = lib.singleton {
  #  name = "osnoise-tracer";
  #  patch = null;
  #  extraStructuredConfig = with lib.kernel; {
  #    OSNOISE_TRACER = yes;
  #    HWLAT_TRACER = yes;
  #  };
  #};

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "nvme" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
}
