#!/bin/sh

# Locate nix daemon pid
nd=$(pgrep -o nix-daemon)

# Locate children of nix-daemon
pids1=$(tr ' ' '\n' < "/proc/$nd/task/$nd/children")

# For each children, locate 2nd level children
pids2=$(echo "$pids1" | xargs -I @ /bin/sh -c 'cat /proc/@/task/*/children' | tr ' ' '\n')

cat <<EOF
HTTP/1.1 200 OK
Content-Type: text/plain; version=0.0.4; charset=utf-8; escaping=values

# HELP nix_daemon_build Nix daemon derivation build state.
# TYPE nix_daemon_build gauge
EOF

for pid in $pids2; do
  name=$(cat /proc/$pid/environ 2>/dev/null | tr '\0' '\n' | rg "^name=(.+)" - --replace '$1' | tr -dc ' [:alnum:]_\-\.')
  user=$(ps -o uname= -p "$pid")
  if [ -n "$name" -a -n "$user" ]; then
    printf 'nix_daemon_build{user="%s",name="%s"} 1\n' "$user" "$name"
  fi
done
