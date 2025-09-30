{
  stdenv
, lib
, bigotes
, cmake
, clangOmpss2
, openmp
, openmpv
, nanos6
, nodes
, nosv
, mpi
, tampi
, openblas
, ovni
, gitBranch ? "master"
, gitURL ? "ssh://git@bscpm04.bsc.es/rarias/bench6.git"
, gitCommit ? "bf29a53113737c3aa74d2fe3d55f59868faea7b4"
}:

stdenv.mkDerivation rec {
  pname = "bench6";
  version = "${src.shortRev}";

  src = builtins.fetchGit {
    url = gitURL;
    ref = gitBranch;
    rev = gitCommit;
  };

  nativeBuildInputs = [
    cmake
    clangOmpss2
  ];

  buildInputs = [
    bigotes
    openmp
    openmpv
    nanos6
    nodes
    nosv
    mpi
    tampi
    openblas
    openblas.dev
    ovni
  ];

  env = {
    NANOS6_HOME = nanos6;
    NODES_HOME = nodes;
    NOSV_HOME = nosv;
  };

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
  ];
  hardeningDisable = [ "all" ];
  dontStrip = true;

  meta = {
    homepage = "https://gitlab.pm.bsc.es/rarias/bench6";
    description = "Set of micro-benchmarks for OmpSs-2 and several mini-apps";
    maintainers = with lib.maintainers.bsc; [ rarias ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
}
