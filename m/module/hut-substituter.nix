{ config, ... }:
{
  nix.settings =
    # Don't add hut as a cache to itself
    assert config.networking.hostName != "hut";
    {
      substituters = [ "http://hut/cache" ];
      trusted-public-keys = [ "jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=" ];
    };
}
