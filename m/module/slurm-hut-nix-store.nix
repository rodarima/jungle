{ ... }:

{
  # Mount the hut nix store via NFS
  fileSystems."/mnt/hut-nix-store" = {
    device = "hut:/nix/store";
    fsType = "nfs";
    options = [ "ro" ];
  };

  systemd.services.slurmd.serviceConfig = {
    # When running a job, bind the hut store in /nix/store so the paths are
    # available too.
    # FIXME: This doesn't keep the programs in /run/current-system/sw/bin
    # available in the store. Ideally they should be merged but the overlay FS
    # doesn't work when the underlying directories change.
    BindReadOnlyPaths = "/mnt/hut-nix-store:/nix/store";
  };
}
