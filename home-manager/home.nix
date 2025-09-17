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
    ./programs/waybar
    ./programs/starship
    ./programs/terminal
    ./programs/tmux
    ./programs/hyprland
    ./programs/gammastep
    ./programs/kanshi
    ./programs/easyeffects
    ./programs/swaynotificationcenter
    # ./programs/qutebrowser
    # ./programs/brave
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
    # ./programs/kunkun
    # ./programs/jan
    # ./programs/llm
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
  xdg.mimeApps.enable = true;
  xdg.mimeApps = {
    defaultApplications = {
      "x-scheme-handler/http" = "zen-browser.desktop";
      "x-scheme-handler/https" = "zen-browser.desktop";
      "x-scheme-handler/chrome" = "zen-browser.desktop";
      "text/html" = "zen-browser.desktop";
      "application/x-extension-htm" = "zen-browser.desktop";
      "application/x-extension-html" = "zen-browser.desktop";
      "application/x-extension-shtml" = "zen-browser.desktop";
      "application/xhtml+xml" = "zen-browser.desktop";
      "application/x-extension-xhtml" = "zen-browser.desktop";
      "application/x-extension-xht" = "zen-browser.desktop";
    };
    associations.added = {
      "x-scheme-handler/http" = "zen-browser.desktop";
      "x-scheme-handler/https" = "zen-browser.desktop";
      "text/html" = "zen-browser.desktop";
      "application/xhtml+xml" = "zen-browser.desktop";
    };
    associations.removed = {
      "x-scheme-handler/http" = ["com.google.Chrome.desktop" "chromium-browser.desktop"];
      "x-scheme-handler/https" = ["com.google.Chrome.desktop" "chromium-browser.desktop"];
      "text/html" = ["com.google.Chrome.desktop" "chromium-browser.desktop"];
      "application/xhtml+xml" = ["com.google.Chrome.desktop" "chromium-browser.desktop"];
    };
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

  systemd.user.services.vicinae = {
    Unit = {
      Description = "Vicinae launcher server";
      After = "graphical-session.target";
    };
    Service = {
      Type = "simple";
      ExecStart = "${inputs.vicinae.packages.${system}.default}/bin/vicinae server";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  stylix = {
    # cursor.package = pkgs.bibata-cursors;
    # cursor.name = "Bibata-Modern-Ice";
    # cursor.size = 24;
    enable = true;
    image = ../bigsun.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    fonts = {
      serif.name = "Iosevka NF";
      sansSerif.name = "Iosevka NF";
      monospace.name = "Iosevka NF";
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
  };
}
