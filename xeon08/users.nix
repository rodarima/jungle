{ ... }:

{
  users = {
    users.arocanon = {
      uid = 1042;
      isNormalUser = true;
      home = "/home/Computational/arocanon";
      description = "Aleix Roca";
      group = "Computational";
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$hliZiW4tULC/tH7p$pqZarwJkNZ7vS0G5llWQKx08UFG9DxDYgad7jplMD8WkZh5k58i4dfPoWtnEShfjTO6JHiIin05ny5lmSXzGM/";
    };
  };

  security.sudo.extraRules= [{
    users = [ "arocanon" ];
    commands = [{
      command = "ALL" ;
      options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];
}
