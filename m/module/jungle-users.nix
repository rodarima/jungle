{ config, lib, ... }:

with lib;

{
  options = {
    users.jungleUsers = mkOption {
      type = types.attrsOf (types.anything // { check = (x: x ? "hosts"); });
      description = ''
        Same as users.users but with the extra `hosts` attribute, which controls
        access to the nodes by `networking.hostName`.
      '';
    };
  };

  config = let
    allowedUser = host: userConf: builtins.elem host userConf.hosts;
    filterUsers = host: users: filterAttrs (n: v: allowedUser host v) users;
    removeHosts = users: mapAttrs (n: v: builtins.removeAttrs v [ "hosts" ]) users;
    currentHost = config.networking.hostName;
  in {
    users.users = removeHosts (filterUsers currentHost config.users.jungleUsers);
  };
}
