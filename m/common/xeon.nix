{
  # Provides the base system for a xeon node.
  imports = [
    ./base.nix
    ./xeon/console.nix
    ./xeon/fs.nix
    ./xeon/net.nix
    ./xeon/ssh.nix
  ];
}
