{config, ...}: {
  xdg.configFile = {
    "easyeffects" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/programs/easyeffects/config";
      recursive = true;
    };
  };
}
