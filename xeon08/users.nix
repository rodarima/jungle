{ ... }:

{
  security.sudo.extraRules= [{
    users = [ "arocanon" ];
    commands = [{
      command = "ALL" ;
      options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
    }];
  }];
}
