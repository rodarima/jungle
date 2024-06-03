{ ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  # Trim unused blocks weekly
  services.fstrim.enable = true;

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  # Tracing
  fileSystems."/sys/kernel/tracing" = {
    device = "none";
    fsType = "tracefs";
  };

  # Mount a tmpfs into /tmp
  boot.tmp.useTmpfs = true;
}
