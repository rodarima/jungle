{ ... }:

{
  users.users = {
    vlopez = {
      uid = 4334;
      isNormalUser = true;
      home = "/home/Computational/vlopez";
      description = "Victor López";
      group = "Computational";
      hashedPassword = "$6$0ZBkgIYE/renVqtt$1uWlJsb0FEezRVNoETTzZMx4X2SvWiOsKvi0ppWCRqI66S6TqMBXBdP4fcQyvRRBt0e4Z7opZIvvITBsEtO0f0";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGMwlUZRf9jfG666Qa5Sb+KtEhXqkiMlBV2su3x/dXHq victor@arch"
      ];
    };
  };
}
