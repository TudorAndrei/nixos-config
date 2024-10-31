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
    swaynotificationcenter
    libnotify
    hyperfine
    alacritty
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
    eza
    lazydocker
    overskride
    wdisplays
    localsend
    spotify
    wttrbar
    jq
    yt-dlp
    imagemagick
    anydesk
  ];
  fonts.fontconfig.enable = true;
  home.file = {
    # ".tmux.conf" = {source = ./tmux.conf;};
    # ".config/alacritty/alacritty.toml" = {source = ./alacritty.toml;};
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    # ".config/waybar" = {
    #   source = ./waybar;
    #   recursive = true;
    # };
    # ".config/starship.toml" = {source = ./starship.toml;};
    # ".config/hypr" = {
    #   source = ./hypr;
    #   recursive = true;
    # };
  };

  programs.starship.enable = true;

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

  programs.zoxide.enable = true;
  programs.zsh = {
    # PERF: Use to debug performance
    # zprof.enable=true;
    enable = true;
    syntaxHighlighting.enable = true;
    antidote = {
      enable = true;
      plugins = [
        ''
          "zsh-users/zsh-history-substring-search"
        ''
      ];
    };
    completionInit = ''
      if [[ -n $(print ~/.zcompdump(Nmh+24)) ]] {
        compinit
      } else {
        compinit -C
      }
    '';
    initExtra = ''
      pdfcompress ()
      {
        gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 -sOutputFile=$\{1%.*\}.compressed.pdf $1;
      }
      screengrab() {
        VIDDIR=$HOME/Videos/Screengrabs
        [ ! -d "$VIDDIR" ] && mkdir "$VIDDIR"
        RES=$(xrandr |grep \* | awk '{print $1}')
        ffmpeg -y -f x11grab -video_size "$RES" -framerate 30 -i :0.0 -f pulse -ac 2 -i 0 -c:v libx264 -pix_fmt yuv420p -s "$RES" -preset ultrafast -c:a libfdk_aac -b:a 128k -threads 0 -strict normal -bufsize 2000k "$VIDDIR"/"$1".mp4
      }
    '';
    shellAliases = {
      update = "sudo nixos-rebuild switch --flake .#sparta";
      nhs = "nh home switch";
      nos = "nh os switch";
      n = "nvim";
      afz = "alias | fzf";
      speedtest = "curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -";
      bigfiles = "du -hs $(ls -A) | sort -rh | head -5";
      k = "eza --long --git";
      sv = "source .venv/bin/activate";
      dcu = "docker compose up";
      dcud = "docker compose up -d";
      dcd = "docker compose down";
      rwb = "killall -SIGUSR2 .waybar-wrapped";
      rhl = "hyprctl reload";
      # GPU
      gput = "python -c 'import torch;print(torch.cuda.is_available())'";
      gputf = "python -c 'import tensorflow as tf;tf.config.list_physical_devices()'";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      share = true;
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
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
