{ config, lib, pkgs, ... }:

let
  cfg = config.services.p;
in
{
  options = {
    services.p = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the p service.";
      };
      path = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/p";
        description = "Where to save the pasted files on disk.";
      };
      url = lib.mkOption {
        type = lib.types.str;
        default = "https://jungle.bsc.es/p";
        description = "URL prefix for the printed file.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = let 
      p = pkgs.writeShellScriptBin "p" ''
        set -e
        pastedir="${cfg.path}/$USER"
        cd "$pastedir"

        ext="txt"
        if [ -n "$1" ]; then
          ext="$1"
        fi

        out=$(mktemp "XXXXXXXX.$ext")
        cat > "$out"
        chmod go+r "$out"
        echo "${cfg.url}/$USER/$out"
      '';
    in [ p ];

    systemd.services.p = let
      # Take only normal users
      users = lib.filterAttrs (_: v: v.isNormalUser) config.users.users;
      # Create a directory for each user
      commands = lib.concatLists (lib.mapAttrsToList (_: user: [
        "install -d -o ${user.name} -g ${user.group} -m 0755 ${cfg.path}/${user.name}"
      ]) users);
    in {
      description = "P service setup";
      requires = [ "network-online.target" ];
      #wants = [ "remote-fs.target" ];
      #after = [ "remote-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "p-init.sh" (''

          install -d -o root -g root -m 0755 ${cfg.path}

        '' + (lib.concatLines commands));
      };
    };
  };
}
