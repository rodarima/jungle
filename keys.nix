# As agenix needs to parse the secrets from a standalone .nix file, we describe
# here all the public keys
rec {
  hosts = {
    hut   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICO7jIp6JRnRWTMDsTB/aiaICJCl4x8qmKMPSs4lCqP1 hut";
    owl1  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqMEXO0ApVsBA6yjmb0xP2kWyoPDIWxBB0Q3+QbHVhv owl1";
    owl2  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHurEYpQzNHqWYF6B9Pd7W8UPgF3BxEg0BvSbsA7BAdK owl2";
    eudy  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+WYPRRvZupqLAG0USKmd/juEPmisyyJaP8hAgYwXsG eudy";
    koro  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImiTFDbxyUYPumvm8C4mEnHfuvtBY1H8undtd6oDd67 koro";
    bay   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvGBzpRQKuQYHdlUQeAk6jmdbkrhmdLwTBqf3el7IgU bay";
    lake2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINo66//S1yatpQHE/BuYD/Gfq64TY7ZN5XOGXmNchiO0 lake2";
  };

  hostGroup = with hosts; rec {
    compute    = [ owl1 owl2 ];
    playground = [ eudy koro ];
    storage    = [ bay lake2 ];
    monitor    = [ hut ];

    system     = storage ++ monitor;
    safe       = system ++ compute;
    all        = safe ++ playground;
  };

  admins = {
    rarias = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1oZTPtlEXdGt0Ak+upeCIiBdaDQtcmuWoTUCVuSVIR rarias@hut";
    root   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII/1TNArcwA6D47mgW4TArwlxQRpwmIGiZDysah40Gb root@hut";
  };
}
