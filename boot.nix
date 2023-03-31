{ ... }:

{
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

  # Enable serial console
  boot.kernelParams = [
    "console=tty1"
    "console=ttyS0,115200"
  ];
}
