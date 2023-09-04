{ config, pkgs, ... }:

# Mounts the /ceph filesystem at boot
{
  environment.systemPackages = with pkgs; [
    ceph
    ceph-client
    fio # For benchmarks
  ];

  # We need the ceph module loaded as the mount.ceph binary fails to run the
  # modprobe command.
  boot.kernelModules = [ "ceph" ];

  age.secrets.cephUser.file = ../../secrets/ceph-user.age;

  fileSystems."/ceph" = {
    fsType = "ceph";
    device = "user@9c8d06e0-485f-4aaf-b16b-06d6daf1232b.cephfs=/";
    options = [
      "mon_addr=10.0.40.40"
      "secretfile=${config.age.secrets.cephUser.path}"
    ];
  };
}
