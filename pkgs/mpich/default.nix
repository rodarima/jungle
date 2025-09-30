{
  stdenv
, lib
, libfabric
, mpich
, pmix
, gfortran
, symlinkJoin
}:

let
  # pmix comes with the libraries in .out and headers in .dev
  pmixAll = symlinkJoin {
    name = "pmix-all";
    paths = [ pmix.dev pmix.out ];
  };
in mpich.overrideAttrs (old: {
  buildInput = old.buildInputs ++ [
    libfabric
    pmixAll
  ];
  configureFlags = [
    "--enable-shared"
    "--enable-sharedlib"
    "--with-pm=no"
    "--with-device=ch4:ofi"
    "--with-pmi=pmix"
    "--with-pmix=${pmixAll}"
    "--with-libfabric=${libfabric}"
    "--enable-g=log"
  ] ++ lib.optionals (lib.versionAtLeast gfortran.version "10") [
    "FFLAGS=-fallow-argument-mismatch" # https://github.com/pmodels/mpich/issues/4300
    "FCFLAGS=-fallow-argument-mismatch"
  ];
  hardeningDisable = [ "all" ];

  meta = old.meta // {
    maintainers = old.meta.maintainers ++ (with lib.maintainers.bsc; [ rarias ]);
  };
})
