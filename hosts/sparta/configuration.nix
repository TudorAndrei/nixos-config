{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common.nix
    ../modules/asus
  ];

  asus.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];

  boot = {
    blacklistedKernelModules = ["k10temp"];

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
      "btusb"
      "kvm-amd"
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
    "gamemode"
    "wireshark"
  ];
  users.groups.wireshark = {};

  system.stateVersion = "24.05";

  hardware.cpu.amd.updateMicrocode = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.graphics.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau
    libvdpau-va-gl
    vdpauinfo
    libva
    libva-utils
  ];

  hardware.nvidia = {
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:8:0:0";
    };
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    pipewire.jack.enable = true;
  };

  programs = {
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}
