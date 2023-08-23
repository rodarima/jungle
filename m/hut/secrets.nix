let
  rarias  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1oZTPtlEXdGt0Ak+upeCIiBdaDQtcmuWoTUCVuSVIR rarias@hut";
  root    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII/1TNArcwA6D47mgW4TArwlxQRpwmIGiZDysah40Gb";
  hut     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICO7jIp6JRnRWTMDsTB/aiaICJCl4x8qmKMPSs4lCqP1";
  default = [ rarias root hut ];
in
{
  "secrets/ovni-token.age".publicKeys = default;
  "secrets/nosv-token.age".publicKeys = default;
  "secrets/ceph-user.age".publicKeys = default;
}
