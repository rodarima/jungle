{ ... }:

{
  users = {
    mutableUsers = false;
    users.rarias = {
      uid = 1880;
      isNormalUser = true;
      home = "/home/Computational/rarias";
      description = "Rodrigo Arias";
      group = "Computational";
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$u06tkCy13enReBsb$xiI.twRvvTfH4jdS3s68NZ7U9PSbGKs5.LXU/UgoawSwNWhZo2hRAjNL5qG0/lAckzcho2LjD0r3NfVPvthY6/";
    };

    groups = {
      Computational = { gid = 564; };
    };
  };
}
