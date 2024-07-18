{
  # All machines should include this profile.
  # Includes the basic configuration for an Intel server.
  imports = [
    ./base/agenix.nix
    ./base/august-shutdown.nix
    ./base/boot.nix
    ./base/env.nix
    ./base/fs.nix
    ./base/hw.nix
    ./base/net.nix
    ./base/nix.nix
    ./base/ntp.nix
    ./base/rev.nix
    ./base/ssh.nix
    ./base/users.nix
    ./base/watchdog.nix
    ./base/zsh.nix
  ];
}
