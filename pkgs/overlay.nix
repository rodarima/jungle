final: prev:
{
  bsc = prev.bsc.extend (bscFinal: bscPrev: {
    # Set MPICH as default
    mpi = bscFinal.mpich;

    # Configure the network for MPICH
    mpich = with final; prev.mpich.overrideAttrs (old: {
      buildInput = old.buildInputs ++ [
        libfabric
        pmix
      ];
      configureFlags = [
        "--enable-shared"
        "--enable-sharedlib"
        "--with-pm=no"
        "--with-device=ch4:ofi"
        "--with-pmi=pmix"
        "--with-pmix=${final.pmix}"
        "--with-libfabric=${final.libfabric}"
        "--enable-g=log"
      ] ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
        "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
        "FCFLAGS=-fallow-argument-mismatch"
      ];
    });
  });

  # Update ceph to 18.2.0 until it lands in nixpkgs, see:
  # https://github.com/NixOS/nixpkgs/pull/247849
  inherit (prev.callPackage ./ceph.nix {
    lua = prev.lua5_4;
    fmt = prev.fmt_8;
  }) ceph ceph-client;

  prometheus-slurm-exporter = prev.callPackage ./slurm-exporter.nix { };
}
