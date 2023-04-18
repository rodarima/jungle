{ ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/swap"; }
    ];

  # Mount the home via NFS
  fileSystems."/home" = {
    device = "10.0.40.30:/home";
    fsType = "nfs";
    options = [ "nfsvers=3" "rsize=1024" "wsize=1024" "cto" "nofail" ];
  };

  # Tracing
  fileSystems."/sys/kernel/tracing" = {
    device = "none";
    fsType = "tracefs";
  };
}
