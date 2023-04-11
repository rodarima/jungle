let
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII/1TNArcwA6D47mgW4TArwlxQRpwmIGiZDysah40Gb";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICO7jIp6JRnRWTMDsTB/aiaICJCl4x8qmKMPSs4lCqP1";
  systems = [ root system ];
in
{
  "secrets/ovni-token.age".publicKeys = systems;
}
