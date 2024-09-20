{ pkgs, lib, config, ... }:
let
  p = pkgs.writeShellScriptBin "p" ''
    set -e
    cd /ceph
    pastedir="p/$USER"
    mkdir -p "$pastedir"

    ext="txt"

    if [ -n "$1" ]; then
      ext="$1"
    fi

    out=$(mktemp "$pastedir/XXXXXXXX.$ext")

    cat > "$out"
    chmod go+r "$out"
    echo "https://jungle.bsc.es/$out"
  '';
in
{
  environment.systemPackages = with pkgs; [ p ];

  # Make sure we have a directory per user. We cannot use the nice
  # systemd-tmpfiles-setup.service service because this is a remote FS, and it
  # may not be mounted when it runs.
  systemd.services.create-paste-dirs = let
    # Take only normal users in hut
    users = lib.filterAttrs (_: v: v.isNormalUser) config.users.users;
    commands = lib.concatLists (lib.mapAttrsToList
      (_: user: [
        "install -d -o ${user.name} -g ${user.group} -m 0755 /ceph/p/${user.name}"
      ]) users);
    script = pkgs.writeShellScript "create-paste-dirs.sh" (lib.concatLines commands);
  in {
    enable = true;
    wants = [ "remote-fs.target" ];
    after = [ "remote-fs.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = script;
  };
}
