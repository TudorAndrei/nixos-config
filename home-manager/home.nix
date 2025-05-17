{
  outputs,
  config,
  pkgs,
  inputs,
  ...
}: let
  neovim-unwrapped = pkgs.unstable.neovim-unwrapped.overrideAttrs (old: {
    meta =
      old.meta
      or {}
      // {
        maintainers = [];
      };
  });
in {
  imports = [
    inputs.stylix.homeManagerModules.stylix
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
    # ./programs/qutebrowser
    ./programs/brave
    # ./programs/nixcord
    # ./programs/spicetify
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
      inputs.zen-browser.packages."${system}".default # beta
      (callPackage ./programs/opencode/package.nix {})
      # llm
      delta
      google-chrome
      unstable.postman
      unstable.dioxus-cli
      unstable.claude-code
      zoom-us
      scrcpy
      beekeeper-studio
      grimblast
      swaynotificationcenter
      vlc
      slack
      mangohud
      libnotify
      hyperfine
      alacritty
      fnm
      rye
      unstable.uv
      signal-desktop
      brightnessctl
      smplayer
      arandr
      feh
      mpv
      libreoffice
      fd
      zip
      cargo
      slack
      nixd
      distrobox
      alejandra
      qbittorrent-enhanced
      hyprshot
      # Games
      lutris
      kdePackages.krdc
      unstable.xan
      protonup-qt
      winetricks
      wineWowPackages.waylandFull
      wofi
      pavucontrol
      zotero
      pamixer
      tree
      fastfetch
      eza
      unstable.lazydocker
      # wdisplays
      nwg-displays
      localsend
      wttrbar
      jq
      yt-dlp
      imagemagick
      czkawka
      foliate
      dust
      unstable.bruno
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
      openrefine
      libsForQt5.okular
      rustlings
      obsidian
      typst
      unstable.devenv
      heroic
      dbeaver-bin
      unstable.code-cursor
      unzip
      strawberry
      ldtk
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
    rio = {
      enable = true;
      settings = {
        theme = "dracula";
        platform = {
          linux.shell.program = "tmux";
          linux.shell.args = ["new-session" "-c" "/var/www"];
        };
        renderer = {
          backend = "Vulkan";
          performance = "High";
          filters = [
            "${config.home.homeDirectory}/nixos-config/home-manager/programs/rio/slang-shaders/crt/newpixie-crt.slangp"
          ];
        };
      };
    };
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
      # package = pkgs.unstable.neovim;
      package = neovim-unwrapped;
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
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
        delta.dark = true;
        merge.conflictstyle = "zdiff3";
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
        rcp = "rsync -r --info=progress2 --info=name0";
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
      package = pkgs.unstable.vscode.fhs;
      userSettings = {
        "cline.modelSettings.o3Mini.reasoningEffort" = "high";
        "[javascript]" = {
          "editor.defaultFormatter" = "vscode.typescript-language-features";
        };
        "azureResourceGroups.groupBy" = "resourceGroup";
        "[typescriptreact]" = {
          "editor.defaultFormatter" = "rvest.vs-code-prettier-eslint";
        };
        "workbench.colorTheme" = "Stylix";
        "update.mode" = "none";
        "workbench.statusBar.visible" = true;
        "editor.formatOnSave" = true;
        "database-client.autoSync" = true;
        "workbench.sideBar.location" = "right";
        "workbench.startupEditor" = "none";
        "vsc-webshark.sharkdFullPath" = "/home/tudor/.nix-profile/bin/sharkd";
        "git.openRepositoryInParentFolders" = "never";
        "notebook.formatOnSave.enabled" = true;
        "roo-cline.allowedCommands" = [
          "npm test"
          "npm install"
          "tsc"
          "git log"
          "git diff"
          "git show"
        ];
        "github.copilot.chat.commitMessageGeneration.instructions" = [
          {
            "text" = "Use conventional commit message format.";
          }
        ];
        "[json]" = {
          "editor.defaultFormatter" = "vscode.json-language-features";
        };
        "vim.useSystemClipboard" = true;
      };
    };
  };

  stylix = {
    enable = true;
    image = ../bigsun.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    fonts = {
      serif.package = pkgs.nerdfonts;
      serif.name = "Iosevka NF";
      sansSerif.package = pkgs.nerdfonts;
      sansSerif.name = "Iosevka NF";
      monospace.package = pkgs.nerdfonts;
      monospace.name = "Iosevka NF";
      emoji.package = pkgs.noto-fonts-emoji;
      emoji.name = "Noto Color Emoji";
    };
    targets = {
      spicetify.enable = false;
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
