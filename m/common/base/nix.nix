{ pkgs, nixpkgs, bscpkgs, theFlake,  ... }:

{
  nixpkgs.overlays = [
    bscpkgs.bscOverlay
    (import ../../../pkgs/overlay.nix)
  ];

  nix = {
    nixPath = [
      "nixpkgs=${nixpkgs}"
      "jungle=${theFlake.outPath}"
    ];

    registry = {
      nixpkgs.flake = nixpkgs;
      jungle.flake = theFlake;
    };

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      sandbox = "relaxed";
      trusted-users = [ "@wheel" ];
      flake-registry = pkgs.writeText "global-registry.json"
        ''{"flakes":[],"version":2}'';
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # The nix-gc.service can begin its execution *before* /home is mounted,
  # causing it to remove all gcroots considering them as stale, as it cannot
  # access the symlink. To prevent this problem, we force the service to wait
  # until /home is mounted as well as other remote FS like /ceph.
  systemd.services.nix-gc = {
    # Start remote-fs.target if not already being started and fail if it fails
    # to start. It will also be stopped if the remote-fs.target fails after
    # starting successfully.
    bindsTo = [ "remote-fs.target" ];
    # Wait until remote-fs.target fully starts before starting this one.
    after = [ "remote-fs.target"];
    # Ensure we can access a remote path inside /home
    unitConfig.ConditionPathExists = "/home/Computational";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
