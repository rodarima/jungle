{
  imports = [
    ../../module/power-policy.nix
  ];

  # Turn on as soon as we have power
  power.policy = "always-on";
}
