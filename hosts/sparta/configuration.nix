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
  imports = [
    ./hardware-configuration.nix
    ../common.nix
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];

  boot = {
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower];

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
    loader.timeout = 0;
  };

  networking.hostName = "sparta";
  # Additional environment variables specific to this host
  environment.sessionVariables.XDG_SCREENSHOTS_DIR = "$HOME/Pictures/screenshots";

  # Additional user groups specific to this host
  users.users.tudor.extraGroups = [
    "adbusers"
    "gamemode"
    "wireshark"
  ];
  users.groups.wireshark = {};

  # Host-specific packages
  environment.systemPackages = with pkgs; [
    nvidia-offload
    gnome-disk-utility
  ];

  system.stateVersion = "24.05";

  # Hardware configuration specific to sparta
  hardware.cpu.amd.updateMicrocode = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau
    libvdpau-va-gl
    nvidia-vaapi-driver
    vdpauinfo
    libva
    libva-utils
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    forceFullCompositionPipeline = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
      };
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  # Override stylix font names
  stylix.fonts = {
    serif.name = "Iosevka NF";
    sansSerif.name = "Iosevka NF";
    monospace.name = "Iosevka NF";
  };

  # Services specific to sparta
  services = {
    supergfxd.enable = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };

    acpid = {
      enable = true;
      logEvents = true;
      handlers = {
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

    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    pipewire.jack.enable = true;
  };

  # Host-specific programs
  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };
}
