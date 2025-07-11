{
  # Provides the base system for a xeon node in the SSF rack.
  imports = [
    ./xeon.nix
    ./ssf/fs.nix
    ./ssf/hosts.nix
    ./ssf/net.nix
    ./ssf/ssh.nix
  ];
}
