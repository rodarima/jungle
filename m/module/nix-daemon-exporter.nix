{ pkgs, config, lib, ... }:
let
  script = pkgs.runCommand "nix-daemon-exporter.sh" { }
    ''
      cp ${./nix-daemon-builds.sh} $out;
      chmod +x $out
    ''
  ;
in
{
  systemd.services.nix-daemon-exporter = {
    description = "Daemon to export nix-daemon metrics";
    path = [ pkgs.procps pkgs.ripgrep ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.socat}/bin/socat TCP4-LISTEN:9999,fork EXEC:${script}";
      # Needed root to read the environment, potentially unsafe
      User = "root";
      Group = "root";
    };
  };
}
