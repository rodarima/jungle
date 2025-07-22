{ lib, config, pkgs, ... }:
{
  # Configure Nvidia driver to use with CUDA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  hardware.nvidia.open = lib.mkDefault (builtins.abort "hardware.nvidia.open not set");
  hardware.graphics.enable = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # enable support for derivations which require nvidia-gpu to be available
  # > requiredSystemFeatures = [ "cuda" ];
  programs.nix-required-mounts.enable = true;
  programs.nix-required-mounts.presets.nvidia-gpu.enable = true;
  # They forgot to add the symlink
  programs.nix-required-mounts.allowedPatterns.nvidia-gpu.paths = [
    config.systemd.tmpfiles.settings.graphics-driver."/run/opengl-driver"."L+".argument
  ];

  environment.systemPackages = [ pkgs.cudainfo ];
}
