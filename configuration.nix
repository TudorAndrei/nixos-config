{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix];

  # Bootloader.
  boot = {
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        # By default we would install all themes
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
  networking.hostName = "sparta"; # Define your hostname.

  # Networking
  networking = {
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
  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
    debug = false;
  };
  services.xserver.desktopManager.gnome.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/tudor/nixos-config";
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # Add these for better NVIDIA Wayland support
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia"; # For VAAPI
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tudor = {
    isNormalUser = true;
    description = "tudor";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
  };

  # Install firefox.
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    nativeMessagingHosts.packages = [pkgs.firefoxpwa];
  };
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile
  #
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  environment.systemPackages = with pkgs; [
    firefoxpwa
    wl-clipboard
    alsa-utils
    asusctl
    kitty
    wget
    curl
    easyeffects
    vim
    home-manager
    nvitop
    btop
    kanata
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
    hyprlock
    hypridle
    hyprpaper
    steam
    nautilus
    killall
    ghostscript
    clang
    graphviz
    # ASUS
    asusctl # ROG laptop controls
    supergfxctl # Graphics switching utility
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Steam Remote Play.
    dedicatedServer.openFirewall = true; # Source Dedicated Server.
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = -19;
      };
    };
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    gcc
    zlib
    go
    lua
    ripgrep
    fd
    clang
    graphviz
    rye
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  #

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  services.xserver.videoDrivers = ["nvidia"];
  services.blueman.enable = true;
  # hardware.cpu.amd.updateMicrocode = true; # If you're using AMD CPU
  hardware = {
    pulseaudio = {
      enable = false;
      extraModules = [pkgs.pulseaudio-modules-bt];
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = "true";
          FastConnectable = "true";
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };

    firmware = [pkgs.linux-firmware];
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      forceFullCompositionPipeline = true; # Can help with tearing
      prime = {
        sync.enable = true;
        nvidiaBusId = "PCI:1:0:0";
        amdgpuBusId = "PCI:8:0:0";
      };
    };
  };

  services.kanata = {
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

  programs.zsh.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode" "CascadiaCode"];})
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
    enable = true;
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
    targets = {
      # Disable this so I can set the theme from the system and specify a custom one
      # stylix doesn't have a theme option
      plymouth = {enable = false;};
    };
  };
  services.gnome.gnome-keyring.enable = true;
  # Docker virtualisation.docker.enable = true;
  virtualisation.oci-containers.backend = "docker";
  # ASUS
  services.asusd = {
    enable = true;
    enableUserService = true; # Enable per-user control
  };
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;
  services.acpid = {
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
}
