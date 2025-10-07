final: prev:
{
  prometheus-slurm-exporter = prev.callPackage ./slurm-exporter.nix { };
  meteocat-exporter = prev.callPackage ./meteocat-exporter/default.nix { };
  upc-qaire-exporter = prev.callPackage ./upc-qaire-exporter/default.nix { };
  cudainfo = prev.callPackage ./cudainfo/default.nix { };

  amd-uprof = prev.callPackage ./amd-uprof/default.nix { };

  # FIXME: Extend this to all linuxPackages variants. Open problem, see:
  # https://discourse.nixos.org/t/whats-the-right-way-to-make-a-custom-kernel-module-available/4636
  linuxPackages = prev.linuxPackages.extend (_final: _prev: {
    amd-uprof-driver = _prev.callPackage ./amd-uprof/driver.nix { };
  });
  linuxPackages_latest = prev.linuxPackages_latest.extend(_final: _prev: {
    amd-uprof-driver = _prev.callPackage ./amd-uprof/driver.nix { };
  });
}
