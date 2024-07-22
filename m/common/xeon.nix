{
  # Provides the base system for a xeon node.
  imports = [
    ./base.nix
    ./xeon/fs.nix
    ./xeon/console.nix
    ./xeon/net.nix
  ];
}
