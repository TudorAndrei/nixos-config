{
  config,
  lib,
  inputs,
  ...
}: let
  secretsFile = ../../secrets/secrets.yaml;
  hasSecrets = builtins.pathExists secretsFile;
in {
  imports = lib.optionals hasSecrets [inputs.sops-nix.homeManagerModules.sops];

  config = lib.mkIf hasSecrets {
    sops = {
      defaultSopsFile = secretsFile;
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      secrets.npm_token = {};

      templates."npmrc" = {
        path = "${config.home.homeDirectory}/.npmrc";
        mode = "0600";
        content = ''
          //registry.npmjs.org/:_authToken=${config.sops.placeholder.npm_token}
        '';
      };
    };
  };
}
