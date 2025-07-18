{ lib, config, ... }:
{
  # Configure Nvidia driver to use with CUDA
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;
  hardware.nvidia.open = lib.mkDefault (builtins.abort "hardware.nvidia.open not set");
  hardware.graphics.enable = true;
  nixpkgs.config.nvidia.acceptLicense = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
