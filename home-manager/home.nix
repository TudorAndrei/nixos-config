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
  programs.waybar= {
    enable = true;
    package = pkgs.waybar;
    style = ''
@define-color background-darker rgba(30, 31, 41, 230);
@define-color background #282a36;
@define-color selection #44475a;
@define-color foreground #f8f8f2;
@define-color comment #6272a4;
@define-color cyan #8be9fd;
@define-color green #50fa7b;
@define-color orange #ffb86c;
@define-color pink #ff79c6;
@define-color purple #bd93f9;
@define-color red #ff5555;
@define-color yellow #f1fa8c;
* {
    font-family: 'CaskaydiaCove NF';
    border: none;
    border-radius: 0;
    font-family: Iosevka;
    font-size: 11pt;
    min-height: 0;
}
window#waybar {
    opacity: 0.9;
    background: @background-darker;
    color: @foreground;
    border-bottom: 2px solid @background;
}
#workspaces button {
    padding: 0 10px;
    background: @background;
    color: @foreground;
}
#workspaces button:hover {
    box-shadow: inherit;
    text-shadow: inherit;
    background-image: linear-gradient(0deg, @selection, @background-darker);
}
#workspaces button.active {
    background-image: linear-gradient(0deg, @purple, @selection);
}
#workspaces button.urgent {
    background-image: linear-gradient(0deg, @red, @background-darker);
}
#taskbar button.active {
    background-image: linear-gradient(0deg, @selection, @background-darker);
}
#clock {
    padding: 0 4px;
    background: @background;
}
    '';
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
