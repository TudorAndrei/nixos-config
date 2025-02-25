{
  outputs,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nur.modules.homeManager.default
    ./programs/firefox
    ./programs/waybar
    ./programs/starship
    ./programs/alacritty
    ./programs/tmux
    ./programs/hyprland
    ./programs/gammastep
    ./programs/kanshi
    ./programs/easyeffects
    # ./programs/kunkun
  ];
  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
    };
  };
  home = {
    username = "tudor";
    homeDirectory = "/home/tudor";
    stateVersion = "23.11";

    packages = with pkgs; [
      nur.repos.xddxdd.adspower
      zoom-us
      grimblast
      swaynotificationcenter
      slack
      mangohud
      libnotify
      hyperfine
      alacritty
      fnm
      rye
      uv
      signal-desktop
      brightnessctl
      arandr
      feh
      mpv
      libreoffice
      fd
      zip
      cargo
      discord
      slack
      nixd
      alejandra
      hyprshot
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
      eza
      lazydocker
      wdisplays
      localsend
      spotify
      wttrbar
      jq
      yt-dlp
      imagemagick
      czkawka
      foliate
      dust
      calibre
      bruno
      anydesk
      pika-backup
      grim
      slurp
      stremio
      networkmanagerapplet
      pandoc
      transmission_4-gtk
      opustags
      mongodb-compass
      libsForQt5.okular
      rustlings
      obsidian
      typst
      devenv
      heroic
      dbeaver-bin
      code-cursor
      unzip
      strawberry
      ldtk
      brave
      wireshark
      unstable.windsurf
    ];
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

  home.file.".local/bin/update-system" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      echo "🔄 Updating flake inputs..."
      nix flake update

      echo "🖥️  Switching OS configuration..."
      nh os switch

      echo "🏠 Switching Home configuration..."
      nh home switch

      echo "🔍 Checking for changes to commit..."
      if git diff-index --quiet HEAD --; then
          echo "✅ No changes to commit."
      else
          echo "💾 Committing changes..."
          git add -A
          git commit -m "chore: update system and home configurations"
          echo "🚀 Changes committed successfully!"
      fi

      echo "🎉 All done! System and home configurations updated."
    '';
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
    btop = {
      enable = true;
      package = pkgs.btop.override {cudaSupport = true;};
    };
    direnv = {
      config = {
        global.hide_env_diff = true;
      };
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    home-manager.enable = true;
    git = {
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
    zoxide.enable = true;
    zsh = {
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
        # update = "sudo nixos-rebuild switch --flake .#sparta";
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
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
      userSettings = {
        "workbench.colorTheme" = "Stylix";
        "update.mode" = "none";
        "workbench.statusBar.visible" = false;
        "editor.formatOnSave" = true;
        "remote.autoForwardPorts" = false;
        "database-client.autoSync" = true;
        "workbench.sideBar.location" = "right";
        "workbench.startupEditor" = "none";
        "vsc-webshark.sharkdFullPath" = "/home/tudor/.nix-profile/bin/sharkd";
        "git.openRepositoryInParentFolders" = "never";
        "notebook.formatOnSave.enabled" = true;
      };
    };
  };

  stylix = {
    enable = true;
    image = ../bigsun.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    fonts = {
      serif.package = pkgs.nerdfonts;
      serif.name = "CaskaydiaCove NF";

      sansSerif.package = pkgs.nerdfonts;
      sansSerif.name = "CaskaydiaCove NF";

      monospace.package = pkgs.nerdfonts;
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
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
  };

  services.syncthing = {
    enable = true;
  };
}
