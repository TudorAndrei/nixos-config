{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  theme = import ../lib/theme.nix;
  getPackage = path: lib.getAttrFromPath path pkgs;
in {
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

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/home/tudor/.config/sops/age/keys.txt";
  };

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
      allowedTCPPorts = [53317];
      allowedUDPPorts = [53317];
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
    EGL_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OBSIDIAN_USE_WAYLAND = "1";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    STEAM_USE_GPU_SCREEN_CAPTURE = "1";
    BROWSER = "zen-browser";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
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
      "openrazer"
      "dialout"
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
    openrazer = {
      enable = true;
      users = ["tudor"];
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
    enable = true;
    base16Scheme = theme.colors;
    polarity = theme.polarity;
    fonts = {
      serif = {
        package = getPackage theme.fonts.serif.path;
        name = theme.fonts.serif.name;
      };
      sansSerif = {
        package = getPackage theme.fonts.sansSerif.path;
        name = theme.fonts.sansSerif.name;
      };
      monospace = {
        package = getPackage theme.fonts.monospace.path;
        name = theme.fonts.monospace.name;
      };
      emoji = {
        package = getPackage theme.fonts.emoji.path;
        name = theme.fonts.emoji.name;
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

  # Vial keyboard programming udev rules
  services.udev.extraRules = ''
    # VID/PID for Vial-enabled keyboards
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="feed", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # For STM32 bootloader
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # For USBaspLoader
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05df", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # For HID Bootloaders
    ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # For HID Bootloaders - USBAsp
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="05dc", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # For atmega32u4 (qmk)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff4", MODE:="0666"
    # For atmega32u2 (qmk)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2ff0", MODE:="0666"
    # ESP32-C3 serial ports (for crosspoint-reader and other ESP32 development)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="55d4", MODE="0666", GROUP="dialout"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666", GROUP="dialout"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="303a", ATTRS{idProduct}=="1001", MODE="0666", GROUP="dialout"
  '';

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
