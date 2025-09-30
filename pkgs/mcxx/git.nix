{
  stdenv
, lib
, fetchFromGitHub
, autoreconfHook
, nanos6
, gperf
, python
, gfortran
, pkg-config
, sqlite
, flex
, bison
, gcc
}:

stdenv.mkDerivation rec {
  pname = "mcxx";
  version = src.shortRev;

  passthru = {
    CC = "mcc";
    CXX = "mcxx";
  };

  src = builtins.fetchGit {
    url = "ssh://git@bscpm04.bsc.es/mercurium/mcxx";
    ref = "master";
  };

  enableParallelBuilding = true;

  buildInputs = [
    autoreconfHook
    nanos6
    gperf
    python
    gfortran
    pkg-config
    sqlite.dev
    bison
    flex
    gcc
  ];

  # TODO: Not sure if we need this patch anymore (?)
  #patches = [ ./intel.patch ];

  preConfigure = ''
    export ICC=icc
    export ICPC=icpc
    export IFORT=ifort
  '';

  configureFlags = [
    "--enable-ompss-2"
    "--with-nanos6=${nanos6}"
# Fails with "memory exhausted" with bison 3.7.1
#    "--enable-bison-regeneration"
  ];

  meta = {
    homepage = "https://github.com/bsc-pm/mcxx";
    description = "C/C++/Fortran source-to-source compilation infrastructure aimed at fast prototyping";
    maintainers = with lib.maintainers.bsc; [ rpenacob ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
}
