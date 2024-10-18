{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  home.username = "tudor";
  home.homeDirectory = "/home/tudor";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    kanata
    alacritty
    fzf
    fnm
    rye
    uv
    unzip
    signal-desktop
    ripgrep
    arandr
    feh
    mpv
    libreoffice
    btop
    ripgrep
    fd
    zip
    unzip
    cargo
    strawberry-qt6
    discord
    slack
    nerdfonts
    lutris
    protonup-qt
    wofi
    tmux
    pavucontrol
    zotero
  ];
  fonts.fontconfig.enable = true;
  home.file = {
    ".tmux.conf" = {source = ./tmux.conf;};
    ".config/alacritty/alacritty.toml" = {source = ./alacritty.toml;};
    ".config/waybar/config.jsonc" = {source = ./waybar.config;};
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/starship.toml" = {source = ./starship.toml;};
    # ".config/hypr" = {
    #   source = ./hypr;
    #   recursive = true;
    # };
  };

  programs.starship.enable = true;
  programs.waybar.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "TudorAndrei";
    userEmail = "tudorandrei.dumitrascu@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };

  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "zsh-users/zsh-history-substring-search";}
        {name = "rimraf/k";}
        {name = "agkozak/zsh-z";}
        {name = "dominik-schwabe/zsh-fnm";}
      ];
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch --flake .#sparta";
      hmu = "home-manager switch --flake .#tudor@sparta";
      n = "nvim";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
