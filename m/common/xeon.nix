{
  # Provides the base system for a xeon node.
  imports = [
    ./base.nix
    ./xeon/fs.nix
    ./xeon/getty.nix
    ./xeon/net.nix
  ];
}
