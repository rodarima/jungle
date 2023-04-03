{ lib, ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

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

  boot.kernelPatches = lib.singleton {
    name = "osnoise-tracer";
    patch = null;
    extraStructuredConfig = with lib.kernel; {
      OSNOISE_TRACER = yes;
      HWLAT_TRACER = yes;
    };
  };
}
