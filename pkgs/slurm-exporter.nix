{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "prometheus-slurm-exporter";
  version = "0.20";

  src = fetchFromGitHub {
    rev = version;
    owner = "vpenso";
    repo = pname;
    sha256 = "sha256-KS9LoDuLQFq3KoKpHd8vg1jw20YCNRJNJrnBnu5vxvs=";
  };

  vendorSha256 = "sha256-A1dd9T9SIEHDCiVT2UwV6T02BSLh9ej6LC/2l54hgwI=";
  doCheck = false;

  meta = with lib; {
    description = "Prometheus SLURM Exporter";
    homepage = "https://github.com/vpenso/prometheus-slurm-exporter";
    platforms = platforms.linux;
  };
}
