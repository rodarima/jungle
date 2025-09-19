# As agenix needs to parse the secrets from a standalone .nix file, we describe
# here all the public keys
rec {
  hosts = {
    hut     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICO7jIp6JRnRWTMDsTB/aiaICJCl4x8qmKMPSs4lCqP1 hut";
    owl1    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqMEXO0ApVsBA6yjmb0xP2kWyoPDIWxBB0Q3+QbHVhv owl1";
    owl2    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHurEYpQzNHqWYF6B9Pd7W8UPgF3BxEg0BvSbsA7BAdK owl2";
    eudy    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL+WYPRRvZupqLAG0USKmd/juEPmisyyJaP8hAgYwXsG eudy";
    koro    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImiTFDbxyUYPumvm8C4mEnHfuvtBY1H8undtd6oDd67 koro";
    bay     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICvGBzpRQKuQYHdlUQeAk6jmdbkrhmdLwTBqf3el7IgU bay";
    lake2   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINo66//S1yatpQHE/BuYD/Gfq64TY7ZN5XOGXmNchiO0 lake2";
    fox     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwItIk5uOJcQEVPoy/CVGRzfmE1ojrdDcI06FrU4NFT fox";
    tent    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFAtTpHtdYoelbknD/IcfBlThwLKJv/dSmylOgpg3FRM tent";
    apex    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBvUFjSfoxXnKwXhEFXx5ckRKJ0oewJ82mRitSMNMKjh apex";
    weasel  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFLJrQ8BF6KcweQV8pLkSbFT+tbDxSG9qxrdQE65zJZp weasel";
    raccoon = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNQttFvL0dNEyy7klIhLoK4xXOeM2/K9R7lPMTG3qvK raccoon";
  };

  hostGroup = with hosts; rec {
    compute    = [ owl1 owl2 fox raccoon ];
    playground = [ eudy koro weasel ];
    storage    = [ bay lake2 ];
    monitor    = [ hut ];
    login      = [ apex ];

    system     = storage ++ monitor ++ login;
    safe       = system ++ compute;
    all        = safe ++ playground;
  };

  admins = {
    "rarias@hut"  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1oZTPtlEXdGt0Ak+upeCIiBdaDQtcmuWoTUCVuSVIR rarias@hut";
    "rarias@tent" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIwlWSBTZi74WTz5xn6gBvTmCoVltmtIAeM3RMmkh4QZ rarias@tent";
    "rarias@fox"  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDSbw3REAKECV7E2c/e2XJITudJQWq2qDSe2N1JHqHZd rarias@fox";
    root          = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIII/1TNArcwA6D47mgW4TArwlxQRpwmIGiZDysah40Gb root@hut";
  };
}
