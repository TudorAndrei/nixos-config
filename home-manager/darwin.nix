{
  config,
  pkgs,
  ...
}: let
  reloadGhostty = pkgs.writeShellScript "reload-ghostty-config" ''
    killall -USR2 ghostty 2>/dev/null || true
  '';
in {
  imports = [
    ./shared
    ./macos
  ];

  home = {
    username = "tudor";
    homeDirectory = "/Users/tudor";
    stateVersion = "25.11";

    packages = import ./packages/darwin.nix {inherit pkgs;};
  };

  launchd.agents.ghostty-config-reload = {
    enable = true;
    config = {
      ProgramArguments = ["${reloadGhostty}"];
      ProcessType = "Background";
      WatchPaths = ["${config.xdg.configHome}/ghostty"];
    };
  };

  programs.home-manager.enable = true;
}
