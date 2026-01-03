{config, ...}: {
  services.easyeffects = {
    enable = true;
  };
  xdg.configFile = {
    "easyeffects" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/programs/easyeffects/config/db";
      recursive = true;
    };
  };
  xdg.dataFile = {
    "easyeffects" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/programs/easyeffects/data";
      recursive = true;
    };
  };
}
