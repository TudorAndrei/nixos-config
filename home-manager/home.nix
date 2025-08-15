{
  outputs,
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
     inputs.stylix.homeModules.stylix
     inputs.nur.modules.homeManager.default
    ./programs/zen-browser
    ./programs/waybar
    ./programs/starship
    ./programs/terminal
    ./programs/tmux
    ./programs/hyprland
    ./programs/gammastep
    ./programs/kanshi
    ./programs/easyeffects
    # ./programs/qutebrowser
    ./programs/brave
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
    # ./programs/spicetify
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
    stateVersion = "23.11";

    packages = with pkgs; (import ./packages {inherit pkgs inputs system;});
  };

  # TODO: Link .config/easyeffects with nixos
  fonts.fontconfig.enable = true;
  xdg.mimeApps.enable = true;
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/nvim";
      recursive = true;
    };
    "nvim/init.lua".enable = false;
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

  programs = {
    home-manager.enable = true;
  };

  services.mako = {
    enable = true;
    # Add any other mako configuration options here
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
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OBSIDIAN_USE_WAYLAND = "1";
    LD_LIBRARY_PATH = "${pkgs.graphviz}/lib";
    LDFLAGS = "-L${pkgs.graphviz}/lib";
    CFLAGS = "-I${pkgs.graphviz}/include";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
  };
}
