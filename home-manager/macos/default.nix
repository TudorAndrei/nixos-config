{config, ...}: let
  repo = "${config.home.homeDirectory}/nixos-config";
  macos = path: config.lib.file.mkOutOfStoreSymlink "${repo}/home-manager/macos/${path}";
in {
  xdg.configFile = {
    "barrs/barrs.lua".source = macos "barrs/barrs.lua";
    "rift/config.toml".source = macos "rift/config.toml";
    "menuanywhere/config.json".source = macos "menuanywhere/config.json";
  };
}
