{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [./programs];
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
    pamixer
    tree
    fastfetch
    strawberry-qt6
    lazydocker
  ];
  fonts.fontconfig.enable = true;
  home.file = {
    ".tmux.conf" = {source = ./tmux.conf;};
    ".config/alacritty/alacritty.toml" = {source = ./alacritty.toml;};
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./waybar;
      recursive = true;
    };
    ".config/starship.toml" = {source = ./starship.toml;};
    ".config/hypr" = {
      source = ./hypr;
      recursive = true;
    };
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
    antidote = {
      enable = true;
      plugins = [''
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"
        "rimraf/k"
        "agkozak/zsh-z"
        "dominik-schwabe/zsh-fnm"
      ''
      ];
    };
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake .#sparta";
      nhs = "nh home switch";
      nos = "nh os switch";
      n = "nvim";
      afz = "alias | fzf";
      speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";
      bigfiles="du -hs $(ls -A) | sort -rh | head -5";
      # GPU
      gput="python -c 'import torch;print(torch.cuda.is_available())'";
      gputf="python -c 'import tensorflow as tf;tf.config.list_physical_devices()'";

    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
  # TODO: ssh config
  # programs.ssh.matchBlocks = {
  #     "lassul.us" = {
  #       identityFile = "~/.ssh/card_rsa.pub";
  #       identitiesOnly = true;
  #       user = "download";
  #       port = 45621;
  #     };
  # };
}
