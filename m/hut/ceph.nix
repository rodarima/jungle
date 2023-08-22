{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ceph-client ];

  # We need the ceph module loaded as the mount.ceph binary fails to run the
  # modprobe command.
  boot.kernelModules = [ "ceph" ];

  fileSystems."/ceph" = {
    fsType = "ceph";
    device = "animal@9c8d06e0-485f-4aaf-b16b-06d6daf1232b.cephfs=/";
  };
}
