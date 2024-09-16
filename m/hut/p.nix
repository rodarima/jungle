{ pkgs, ... }:
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
}
