{
  outputs,
  config,
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  theme = import ../lib/theme.nix;
  getPackage = path: lib.getAttrFromPath path pkgs;
in {
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.stylix.homeModules.stylix
    inputs.nur.modules.homeManager.default
    inputs.vicinae.homeManagerModules.default
    ./programs/waybar
    ./programs/starship
    ./programs/terminal
    ./programs/tmux
    ./programs/hyprland
    ./programs/gammastep
    ./programs/kanshi
    ./programs/easyeffects
    ./programs/swaynotificationcenter
    ./programs/helium
    ./programs/vscode
    ./programs/git
    ./programs/zsh
    ./programs/btop
    ./programs/direnv
    ./programs/fzf
    ./programs/zoxide
    ./programs/syncthing
    ./programs/neovim
    ./programs/spicetify
    ./programs/systemd
  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.llm-agents.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };
  home = {
    username = "tudor";
    homeDirectory = "/home/tudor";
    stateVersion = "25.11";

    packages = import ./packages {inherit pkgs inputs system;};
  };

  fonts.fontconfig.enable = true;
  xdg.mimeApps = let
    value = let
      zen-browser = inputs.zen-browser.packages.${system}.beta;
    in
      zen-browser.meta.desktopFileName;

    associations = builtins.listToAttrs (map (name: {
        inherit name value;
      }) [
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-html"
        "application/x-extension-xht"
        "application/x-extension-htm"
        "x-scheme-handler/unknown"
        "x-scheme-handler/mailto"
        "x-scheme-handler/chrome"
        "x-scheme-handler/about"
        "x-scheme-handler/https"
        "x-scheme-handler/http"
        "application/xhtml+xml"
        "application/json"
        "text/plain"
        "text/html"
      ]);
  in {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/nvim";
      recursive = true;
    };
    "nvim/init.lua".enable = false; # Never Change
  };

  home.file."pythia/.gitconfig-pythia" = {
    text = ''
      [user]
          name = TudorAndrei-Pythia
          email = tudor@pythia.social
      [url "pythia"]
          insteadOf = "git@github.com"
      [github]
          user = "TudorAndrei-Pythia"
    '';
  };
  home.file."work/.gitconfig-cognisync" = {
    text = ''
      [user]
          user = tudordumitrascu-cognisync
          email = tudor.dumitrascu@cogni-sync.com
      [url "cognisync"]
          insteadOf = "git@github.com"
      [github]
          user = "tudordumitrascu-cognisync"
    '';
  };

  programs.home-manager.enable = true;
  programs.zen-browser.enable = true;
  programs.zen-browser.nativeMessagingHosts = [pkgs.vdhcoapp];

  services.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      autoStart = true;
    };
    settings = {
      faviconService = lib.mkForce "twenty";
      font.size = lib.mkForce 11;
      popToRootOnClose = lib.mkForce false;
      rootSearch.searchFiles = lib.mkForce false;
      theme.name = lib.mkForce "vicinae-dark";
      window = {
        csd = lib.mkForce true;
        opacity = lib.mkForce 0.95;
        rounding = lib.mkForce 10;
      };
    };
  };
  stylix = {
    enable = true;
    image = ../bigsun.jpg;
    base16Scheme = theme.colors;
    polarity = theme.polarity;
    cursor = {
      package = getPackage theme.cursor.path;
      name = theme.cursor.name;
      size = theme.cursor.size;
    };
    fonts = {
      serif = {
        package = getPackage theme.fonts.serif.path;
        name = theme.fonts.serif.name;
      };
      sansSerif = {
        package = getPackage theme.fonts.sansSerif.path;
        name = theme.fonts.sansSerif.name;
      };
      monospace = {
        package = getPackage theme.fonts.monospace.path;
        name = theme.fonts.monospace.name;
      };
      emoji = {
        package = getPackage theme.fonts.emoji.path;
        name = theme.fonts.emoji.name;
      };
    };
    targets.zen-browser.profileNames = ["Default"];
  };

  home.sessionVariables = {
    LD_LIBRARY_PATH = "${pkgs.graphviz}/lib";
    LDFLAGS = "-L${pkgs.graphviz}/lib";
    CFLAGS = "-I${pkgs.graphviz}/include";
  };
}
