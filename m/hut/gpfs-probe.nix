{ pkgs, config, lib, ... }:
let
  gpfs-probe-script = pkgs.runCommand "gpfs-probe.sh" { }
    ''
      cp ${./gpfs-probe.sh} $out;
      chmod +x $out
    ''
  ;
in
{
  # Use a new user to handle the SSH keys
  users.groups.ssh-robot = { };
  users.users.ssh-robot = {
    description = "SSH Robot";
    isNormalUser = true;
    home = "/var/lib/ssh-robot";
  };

  systemd.services.gpfs-probe = {
    description = "Daemon to report GPFS latency via SSH";
    path = [ pkgs.openssh pkgs.netcat ];
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.socat}/bin/socat TCP4-LISTEN:9966,fork EXEC:${gpfs-probe-script}";
      User = "ssh-robot";
      Group = "ssh-robot";
    };
  };
}
