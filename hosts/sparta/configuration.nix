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
      "pcie_aspm=force"
      "iommu=pt"
      "acpi=force"
      "acpi_backlight=vendor"
      "acpi_enforce_resources=lax"

      "module_blacklist=nouveau"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
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
    libva-vdpau-driver
    libvdpau
    libvdpau-va-gl
    vdpauinfo
    libva
    libva-utils
  ];

  hardware.nvidia = {
    prime = {
      sync.enable = true;
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = lib.mkIf config.hardware.nvidia.prime.offload.enable true;
      # };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:8:0:0";
    };
    powerManagement.enable = true;
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
    logind.settings.Login = {
      HandleSuspendKey = "suspend";
      HandleHibernateKey = "suspend";
    };
  };

  systemd.sleep.extraConfig = ''
    [Sleep]
    HibernateMode=shutdown
  '';

  systemd.services.systemd-suspend.serviceConfig.ExecStartPost = lib.mkForce [
    "${pkgs.writeShellScript "display-resume" ''
      sleep 2
      if [ -d /sys/class/drm ]; then
        for card in /sys/class/drm/card*/status; do
          if [ -f "$card" ]; then
            echo on > "$card" 2>/dev/null || true
          fi
        done
      fi
      if [ -d /sys/class/backlight ]; then
        for bl in /sys/class/backlight/*/brightness; do
          if [ -f "$bl" ] && [ -f "$(dirname "$bl")/max_brightness" ]; then
            max=$(cat "$(dirname "$bl")/max_brightness")
            echo "$max" > "$bl" 2>/dev/null || true
          fi
        done
      fi
      if command -v loginctl > /dev/null 2>&1; then
        for session in $(loginctl list-sessions --no-legend 2>/dev/null | awk '{print $1}'); do
          if [ -n "$session" ]; then
            user=$(loginctl show-session "$session" -p User --value 2>/dev/null || true)
            uid=$(loginctl show-session "$session" -p User --value 2>/dev/null | xargs id -u 2>/dev/null || true)
            if [ -n "$uid" ] && [ "$uid" != "0" ]; then
              xdg_runtime="/run/user/$uid"
              if [ -d "$xdg_runtime" ] && [ -S "$xdg_runtime/wayland-0" ] 2>/dev/null; then
                runuser -u "$user" -- XDG_RUNTIME_DIR="$xdg_runtime" hyprctl dispatch dpms on 2>/dev/null || true
              fi
            fi
          fi
        done
      fi
    ''}"
  ];

  environment.etc."systemd/system-sleep/display-resume" = {
    mode = "0755";
    text = ''
      #!${pkgs.bash}/bin/bash
      exec > /tmp/display-resume.log 2>&1
      echo "display-resume hook called: $1 $2 at $(date)"
      if [ "$1" = "post" ] && [ "$2" = "suspend" ]; then
        echo "Running post-suspend display restore"
        sleep 3
        if [ -d /sys/class/drm ]; then
          echo "Turning on DRM cards"
          for card in /sys/class/drm/card*/status; do
            if [ -f "$card" ]; then
              echo "Setting $card to on"
              echo on > "$card" 2>&1 || echo "Failed to set $card"
            fi
          done
        fi
        if [ -d /sys/class/backlight ]; then
          echo "Restoring backlight"
          for bl in /sys/class/backlight/*/brightness; do
            if [ -f "$bl" ] && [ -f "$(dirname "$bl")/max_brightness" ]; then
              max=$(cat "$(dirname "$bl")/max_brightness")
              echo "Setting brightness to $max for $bl"
              echo "$max" > "$bl" 2>&1 || echo "Failed to set brightness"
            fi
          done
        fi
        if command -v loginctl > /dev/null 2>&1; then
          echo "Checking user sessions"
          for session in $(loginctl list-sessions --no-legend 2>/dev/null | awk '{print $1}'); do
            if [ -n "$session" ]; then
              user=$(loginctl show-session "$session" -p User --value 2>/dev/null || true)
              uid=$(loginctl show-session "$session" -p User --value 2>/dev/null | xargs id -u 2>/dev/null || true)
              echo "Found session $session for user $user (uid $uid)"
              if [ -n "$uid" ] && [ "$uid" != "0" ]; then
                xdg_runtime="/run/user/$uid"
                if [ -d "$xdg_runtime" ] && [ -S "$xdg_runtime/wayland-0" ] 2>/dev/null; then
                  echo "Calling hyprctl for user $user"
                  runuser -u "$user" -- XDG_RUNTIME_DIR="$xdg_runtime" hyprctl dispatch dpms on 2>&1 || echo "Failed to call hyprctl"
                else
                  echo "Wayland socket not found for user $user"
                fi
              fi
            fi
          done
        fi
        echo "Display resume hook completed at $(date)"
      else
        echo "Not a post-suspend event, skipping"
      fi
    '';
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
  };

  security.pam.services.hyprlock = {};

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
