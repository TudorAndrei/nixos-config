{ ... }:

{
  programs.direnv = {
    config = {
      global.hide_env_diff = true;
    };
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}