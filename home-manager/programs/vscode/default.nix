{
  pkgs,
  config,
  ...
}: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode.fhs;
  };

  xdg.configFile = {
    "settings.json" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/programs/vscode/settings.json";
      recursive = true;
    };
  };
}
