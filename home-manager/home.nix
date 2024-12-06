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
    arandr
    feh
    mpv
    libreoffice
    fd
    zip
    unzip
    cargo
    strawberry-qt6
    discord
    slack
    nixd
    alejandra
    # Games
    lutris
    protonup-qt
    winetricks
    wineWowPackages.waylandFull
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
    wdisplays
    localsend
    spotify
    wttrbar
    jq
    yt-dlp
    imagemagick
    btop
    czkawka
    foliate
    dust
    calibre
    julia_19-bin
    bruno
    anydesk
    pika-backup
    grim
    slurp
    beets
    stremio
    networkmanagerapplet
    pandoc
    transmission_4-gtk
    opustags
    mongodb-compass
    flameshot
    libsForQt5.okular
    racket
    ocaml
    rustlings
  ];
  # TODO: Link .config/easyeffects with nixos
  fonts.fontconfig.enable = true;
  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/home-manager/nvim";
      recursive = true;
    };
    "nvim/init.lua".enable = false;
  };

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
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      filter = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
      core.excludefile = "~/.gitignore_global";
      github.user = "TudorAndrei";
    };
    includes = [
      {
        condition = "gitdir:~/pythia/";
        path = "~/pythia/.gitconfig-pythia";
      }
    ];
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
      ff = "fastfetch";
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
      ".." = "cd ..";
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

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
    userSettings = {
      "workbench.colorTheme" = "Stylix";
      "update.mode" = "none";
      "workbench.statusBar.visible" = false;
      "editor.formatOnSave" = true;
    };
  };

  stylix = {
    enable = true;
    image = ../bigsun.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    fonts = {
      serif.package = pkgs.nerd-fonts.caskaydia-cove;
      serif.name = "CaskaydiaCove NF";

      sansSerif.package = pkgs.nerd-fonts.caskaydia-cove;
      sansSerif.name = "CaskaydiaCove NF";

      monospace.package = pkgs.nerd-fonts.caskaydia-mono;
      monospace.name = "CaskaydiaCove NF";

      emoji.package = pkgs.noto-fonts-emoji;
      emoji.name = "Noto Color Emoji";
    };
  };

  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OBSIDIAN_USE_WAYLAND = "1";
    LD_LIBRARY_PATH = "${pkgs.graphviz}/lib";
    LDFLAGS = "-L${pkgs.graphviz}/lib";
    CFLAGS = "-I${pkgs.graphviz}/include";
  };

  programs.texlive.enable = true;

  services.syncthing = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };
}
