{
  # Provides the base system for a xeon node, not necessarily in the SSF rack.
  imports = [
    ./base.nix
    ./xeon/console.nix
  ];
}
