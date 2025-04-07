{
  config,
  pkgs,
  lib,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  imports = [./hardware-configuration.nix];

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  nix.extraOptions = ''
    trusted-users = root tudor
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

  nixpkgs.config.allowUnfree = true;

  boot = {
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings"];
        })
      ];
    };

    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "amd_pstate=active"
      "pcie_aspm=off"
      "iommu=pt"
      "acpi=force"
      "acpi_backlight=vendor"
      "acpi_enforce_resources=lax"

      "module_blacklist=nouveau"
      "nvidia-drm.modeset=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
    ];
    kernelModules = [
      "asus-nb-wmi"
      "asus-wmi"
      "btusb"
      "kvm-amd"
      "zenpower"
    ];
    extraModprobeConfig = ''
      options btusb enable_autosuspend=n
    '';
    loader = {
      systemd-boot.enable = true;
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "sparta";
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
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
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      # inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
    EGL_PLATFORM = "wayland";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    OBSIDIAN_USE_WAYLAND = "1";
    XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";
  };

  users.users.tudor = {
    isNormalUser = true;
    description = "tudor";
    extraGroups = [
      "video"
      "networkmanager"
      "kvm"
      "adbusers"
      "wheel"
      "audio"
      "docker"
      "gamemode"
      "wireshark"
    ];
  };
  users.groups.wireshark = {};

  environment.systemPackages = with pkgs; [
    nvidia-offload
    firefoxpwa
    wl-clipboard
    alsa-utils
    kitty
    wget
    curl
    easyeffects
    vim
    home-manager
    nvitop
    kanata
    htop-vim
    go
    nodejs_20
    stdenv.cc.cc
    luajitPackages.luarocks
    zlib
    python3
    lua
    ripgrep
    fd
    gcc
    # hyrpland
    hyprpicker
    hyprcursor
    hyprpaper
    nautilus
    killall
    ghostscript
    clang
    graphviz
    ffmpeg
    icu.dev
  ];

  system.stateVersion = "24.05";
  hardware = {
    cpu.amd.updateMicrocode = true; # If you're using AMD CPU
    bluetooth = {
      enable = true;
      powerOnBoot = true;
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
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
        vdpauinfo
        libva
        libva-utils
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      forceFullCompositionPipeline = true; # Can help with tearing
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true; # Provides `nvidia-offload` command.
        };
        # sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        intelBusId = "PCI:0:2:0";
      };
    };
  };

  fonts.packages = with pkgs; [
    nerdfonts
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    font-awesome
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];
  stylix = {
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";

    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    polarity = "dark";
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
      # Disable this so I can set the theme from the system and specify a custom one
      # stylix doesn't have a theme option
      plymouth = {enable = false;};
    };
  };
  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker.enable = true;

  services = {
    gvfs.enable = true;
    udev.packages = [pkgs.android-udev-rules];
    gnome.gnome-keyring.enable = true;

    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    power-profiles-daemon.enable = true;
    thermald.enable = true;
    acpid = {
      enable = true;
      logEvents = true;
      handlers = {
        # Add custom ACPI event handlers if needed
        brightness-up = {
          event = "video/brightnessup";
          action = "${pkgs.asusctl}/bin/asusctl --brightness-up";
        };
        brightness-down = {
          event = "video/brightnessdown";
          action = "${pkgs.asusctl}/bin/asusctl --brightness-down";
        };
      };
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    logind = {
      lidSwitch = "ignore";
      lidSwitchDocked = "ignore";
      lidSwitchExternalPower = "ignore";
      extraConfig = ''
        # don’t shutdown when power button is short-pressed
                HandlePowerKey=ignore
      '';
    };
    blueman.enable = true;

    xserver = {
      videoDrivers = ["nvidia"];
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
        debug = false;
      };
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
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
  systemd.services.NetworkManager-wait-online.enable = false;

  programs = {
    wireshark = {
      enable = true;
    };
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      # portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/tudor/nixos-config";
    };
    firefox = {
      enable = true;
      package = pkgs.firefox;
      nativeMessagingHosts.packages = [pkgs.firefoxpwa];
    };
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
      gcc
      zlib
      go
      lua
      ripgrep
      fd
      clang
      rye
    ];
    zsh.enable = true;
  };
}
