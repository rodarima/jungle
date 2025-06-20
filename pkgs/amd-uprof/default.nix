{ stdenv
, lib
, curl
, cacert
, runCommandLocal
}:

let
  version = "5.1.701";
  tarball = "AMDuProf_Linux_x64_${version}.tar.bz2";

  uprofSrc = runCommandLocal tarball {
    nativeBuildInputs = [ curl ];
    outputHash = "sha256-j9gxcBcIg6Zhc5FglUXf/VV9bKSo+PAKeootbN7ggYk=";
    SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt";
  } ''
    curl \
    -o $out \
    'https://download.amd.com/developer/eula/uprof/uprof-5-1/${tarball}' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:139.0) Gecko/20100101 Firefox/139.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H 'Accept-Encoding: gzip, deflate, br, zstd' \
    -H 'Referer: https://www.amd.com/' 2>&1 | tr '\r' '\n'
  '';

in
  stdenv.mkDerivation {
    pname = "AMD-uProf";
    inherit version;
    src = uprofSrc;
    dontStrip = true;
    phases = [ "installPhase" "fixupPhase" ];
    installPhase = ''
      set -x
      mkdir -p $out
      tar -x -v -C $out --strip-components=1 -f $src
      rm $out/bin/AMDPowerProfilerDriverSource.tar.gz
      set +x
    '';
  }
