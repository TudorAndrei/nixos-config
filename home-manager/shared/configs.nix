{config, ...}: let
  repo = "${config.home.homeDirectory}/nixos-config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${repo}/${path}";
  shared = path: link "home-manager/shared/${path}";
in {
  xdg.configFile = {
    "nvim".source = link "home-manager/nvim";
    "starship.toml".source = shared "starship.toml";
    "mise/config.toml".source = shared "mise/config.toml";
    "uv/uv.toml".source = shared "uv/uv.toml";
    "herdr/config.toml".source = shared "herdr/config.toml";
    "herdr/plugins/config/herdr-navigator/config.toml".source = shared "herdr/plugins/herdr-navigator.toml";
    "herdr-automatic-rename/config.sh".source = shared "herdr/plugins/herdr-automatic-rename.sh";
  };

  home.file = {
    ".bunfig.toml".source = shared "bun/bunfig.toml";
    ".codex/config.toml".source = shared "codex/config.toml";
    ".codex-clean/clean.config.toml".source = shared "codex-clean/clean.config.toml";
  };
}
