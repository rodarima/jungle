{ config, pkgs, ... }:

{
  imports = [
    ../common/main.nix
    ./hardware-configuration.nix

    ./fs.nix
    ./gitlab-runner.nix
    ./monitoring.nix
    ./net.nix
    ./nfs.nix
    ./overlays.nix
    ./slurm.nix
    ./ssh.nix
    ./users.nix

    <agenix/modules/age.nix>
  ];

  # Select the this using the ID to avoid mismatches
  boot.loader.grub.device = "/dev/disk/by-id/ata-INTEL_SSDSC2BB240G7_PHDV6462004Y240AGN";

  systemd.services."serial-getty@ttyS0" = {
    enable = true;
    wantedBy = [ "getty.target" ];
    serviceConfig.Restart = "always";
  };

  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_DK.UTF-8";

  environment.systemPackages = with pkgs; [
    vim wget git htop tmux pciutils tcpdump ripgrep nix-index nixos-option
    nix-diff ipmitool freeipmi ethtool lm_sensors
    (pkgs.callPackage <agenix/pkgs/agenix.nix> {})
  ];

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.sandbox = "relaxed";
  nix.settings.trusted-users = [ "@wheel" ];
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

  programs.zsh.enable = true;
  programs.zsh.histSize = 100000;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
