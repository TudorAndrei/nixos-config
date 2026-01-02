{
  pkgs,
  inputs,
  config,
  ...
}: {
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes" "ca-derivations"];
    substituters = [
      "https://cache.nixos.org/?priority=5"
      "https://hyprland.cachix.org?priority=10"
      "https://vicinae.cachix.org?priority=15"
      "https://nix-community.cachix.org?priority=20"
      "https://nix-gaming.cachix.org?priority=25"
      "https://nixpkgs-wayland.cachix.org?priority=30"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://vicinae.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-wayland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
    # Performance optimizations
    max-jobs = "auto";
    cores = 0;
    # Memory optimizations
    max-free = 4294967296; # 4GB
    min-free = 134217728; # 128MB
  };

  nix.extraOptions = ''
    trusted-users = root tudor
  '';

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.tmp.useTmpfs = true;
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.overcommit_memory" = 1;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_max" = 134217728;
    "net.core.rmem_default" = 16777216;
    "net.core.wmem_default" = 16777216;
    "net.core.netdev_max_backlog" = 5000;
    "net.core.netdev_budget" = 600;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    "net.ipv4.tcp_fin_timeout" = 10;
    "net.ipv4.tcp_keepalive_time" = 120;
    "net.ipv4.tcp_keepalive_probes" = 5;
    "net.ipv4.tcp_keepalive_intvl" = 15;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    "net.ipv4.tcp_tw_reuse" = 1;
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_sack" = 1;
    "net.ipv4.tcp_timestamps" = 1;
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_max_syn_backlog" = 8192;
    "net.ipv4.ip_local_port_range" = "1024 65535";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
  };

  networking = {
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
      settings.main.dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [ 53317 ];
      allowedUDPPorts = [ 53317 ];
    };
    useNetworkd = false;
  };

  users.defaultUserShell = pkgs.zsh;
  time.timeZone = "Europe/Bucharest";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  security = {
    pam.services.gdm.enableGnomeKeyring = true;
    rtkit.enable = true;
    sudo = {
      enable = true;
      extraRules = [
        {
          commands = [
            {
              command = "${pkgs.systemd}/bin/systemctl suspend";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/reboot";
              options = ["NOPASSWD"];
            }
            {
              command = "${pkgs.systemd}/bin/poweroff";
              options = ["NOPASSWD"];
            }
          ];
          groups = ["wheel"];
        }
      ];
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    EGL_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OBSIDIAN_USE_WAYLAND = "1";
    # Steam X11 compatibility
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    STEAM_USE_GPU_SCREEN_CAPTURE = "1";
  };

  users.users.tudor = {
    isNormalUser = true;
    description = "tudor";
    extraGroups = [
      "video"
      "networkmanager"
      "kvm"
      "wheel"
      "audio"
      "docker"
    ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = "true";
          FastConnectable = "true";
          ReconnectAttempts = "7";
          ReconnectIntervals = "1, 2, 3";
          AutoEnable = "true";
        };
      };
    };
    firmware = [pkgs.linux-firmware];
    graphics = {
      enable = true;
      enable32Bit = true;
      package = pkgs.mesa;
      package32 = pkgs.pkgsi686Linux.mesa;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };
    nvidia-container-toolkit.enable = true;
    nvidia = {
      modesetting.enable = true;
      # powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  fonts.packages = with pkgs; [
    # Consolidated nerd-fonts to avoid duplicates
    nerd-fonts.iosevka
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    font-awesome
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  stylix = {
    # cursor.package = pkgs.bibata-cursors;
    # cursor.name = "Bibata-Modern-Ice";
    enable = true;
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
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
    targets = {
      plymouth = {enable = false;};
    };
  };

  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  services = {
    resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      fallbackDns = ["1.1.1.1" "1.0.0.1"];
      extraConfig = ''
        DNSOverTLS=opportunistic
        Cache=yes
        CacheFromLocalhost=no
      '';
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    power-profiles-daemon.enable = true;
    thermald.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    printing.enable = true;
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandleLidSwitchDocked = "ignore";
      HandleLidSwitchExternalPower = "suspend";
      HandlePowerKey = "ignore";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver.videoDrivers = ["nvidia"];
    blueman.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
      debug = false;
    };
    openssh.enable = true;
    upower.enable = true;
    kanata = {
      enable = true;
      keyboards = {
        "logi".config = ''
          (defsrc
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            caps a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )

          (deflayer swapcaps
            grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
            tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
            esc a    s    d    f    g    h    j    k    l    ;    '    ret
            lsft z    x    c    v    b    n    m    ,    .    /    rsft
            lctl lmet lalt           spc            ralt rmet rctl
          )
        '';
      };
    };
  };


  systemd.services.NetworkManager-wait-online.enable = true;
  systemd.services.NetworkManager-wait-online.serviceConfig = {
    TimeoutStartSec = "10s";
  };

  environment.systemPackages = with pkgs; [
    home-manager
  ];

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "/home/tudor/nixos-config";
    };
    # firefox = {
    #   enable = true;
    #   package = pkgs.firefox;
    #   nativeMessagingHosts.packages = [pkgs.firefoxpwa];
    # };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = -19;
        };
      };
    };
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
    ];
    zsh.enable = true;
  };
}
