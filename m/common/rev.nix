{ theFlake, ... }:

let
  rev = if theFlake ? rev then theFlake.rev
    else throw ("Refusing to build from a dirty Git tree!");
in {
  # Save the commit of the config in /etc/configrev
  environment.etc.configrev.text = rev + "\n";

  # Keep a log with the config over time
  system.activationScripts.configRevLog.text = ''
    BOOTED=$(cat /run/booted-system/etc/configrev 2>/dev/null || echo unknown)
    CURRENT=$(cat /run/current-system/etc/configrev 2>/dev/null || echo unknown)
    NEXT=${rev}
    DATENOW=$(date --iso-8601=seconds)
    echo "$DATENOW booted=$BOOTED current=$CURRENT next=$NEXT" >> /var/configrev.log
  '';
}
