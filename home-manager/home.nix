{
  outputs,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    inputs.zen-browser.homeModules.beta
    inputs.stylix.homeModules.stylix
    inputs.nur.modules.homeManager.default
    # inputs.vicinae.homeManagerModules.default
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
    ./programs/nixcord
    ./programs/spicetify
  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };
  home = {
    username = "tudor";
    homeDirectory = "/home/tudor";
    stateVersion = "25.05";

    packages = with pkgs; (import ./packages {inherit pkgs inputs system;});
  };

  # TODO: Link .config/easyeffects with nixos
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

  # services.vicinae = {
  #   enable = true;
  #   autoStart = true;
  #   settings = {
  #     faviconService = "twenty";
  #     font.size = 11;
  #     popToRootOnClose = false;
  #     rootSearch.searchFiles = false;
  #     theme.name = "vicinae-dark";
  #     window = {
  #       csd = true;
  #       opacity = 0.95;
  #       rounding = 10;
  #     };
  #   };
  # };
  stylix = {
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    enable = true;
    image = ../bigsun.jpg;
    base16Scheme = {
      base00 = "282a36"; # Background
      base01 = "44475a"; # Current Line
      base02 = "44475a"; # Selection
      base03 = "6272a4"; # Comment
      base04 = "f8f8f2"; # Foreground
      base05 = "f8f8f2"; # Foreground
      base06 = "f8f8f2"; # Foreground
      base07 = "f8f8f2"; # Foreground
      base08 = "ff5555"; # Red
      base09 = "ffb86c"; # Orange
      base0A = "f1fa8c"; # Yellow
      base0B = "50fa7b"; # Green
      base0C = "8be9fd"; # Cyan
      base0D = "bd93f9"; # Purple
      base0E = "ff79c6"; # Pink
      base0F = "ff79c6"; # Pink
    };
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka NF";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka NF";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka NF";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home.sessionVariables = {
    BROWSER = "zen-browser";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OBSIDIAN_USE_WAYLAND = "1";
    LD_LIBRARY_PATH = "${pkgs.graphviz}/lib";
    LDFLAGS = "-L${pkgs.graphviz}/lib";
    CFLAGS = "-I${pkgs.graphviz}/include";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
    # Steam X11 compatibility
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    STEAM_USE_GPU_SCREEN_CAPTURE = "1";
    # Qt Wayland support for vicinae
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
