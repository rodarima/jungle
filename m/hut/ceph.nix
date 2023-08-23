{ config, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ceph-client ];

  # We need the ceph module loaded as the mount.ceph binary fails to run the
  # modprobe command.
  boot.kernelModules = [ "ceph" ];

  age.secrets."secrets/ceph-user".file = ./secrets/ceph-user.age;

  fileSystems."/ceph" = {
    fsType = "ceph";
    device = "user@9c8d06e0-485f-4aaf-b16b-06d6daf1232b.cephfs=/";
    options = [
      "mon_addr=10.0.40.40"
      "secretfile=${config.age.secrets."secrets/ceph-user".path}"
    ];
  };
}
