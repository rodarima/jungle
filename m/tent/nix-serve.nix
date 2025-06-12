{ config, ... }:

{
  age.secrets.nixServe.file = ../../secrets/nix-serve.age;

  services.nix-serve = {
    enable = true;
    # Only listen locally, as we serve it via ssh
    bindAddress = "127.0.0.1";
    port = 5000;

    secretKeyFile = config.age.secrets.nixServe.path;
    # Public key:
    # jungle.bsc.es:pEc7MlAT0HEwLQYPtpkPLwRsGf80ZI26aj29zMw/HH0=
  };
}
