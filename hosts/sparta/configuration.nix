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
    ../modules/nvidia
  ];

  asus.enable = true;

  nvidia = {
    enable = true;
    prime = {
      mode = "sync";
      nvidiaBusId = "PCI:1:0:0";
      amdBusId = "PCI:8:0:0";
    };
    powerManagement.enable = true;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];

  boot = {
    blacklistedKernelModules = ["k10temp"];
    consoleLogLevel = 0;
    initrd.verbose = false;
    loader.timeout = 0;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"

      "amd_pstate=active"
      "amd_pstate.shared_mem=1"
      "pcie_aspm=force"
      "iommu=pt"
      "acpi=force"
      "acpi_backlight=vendor"
      "acpi_enforce_resources=lax"

      "nowatchdog"
      "nmi_watchdog=0"
      "split_lock_detect=off"
      "tsc=reliable"
      "clocksource=tsc"
      "threadirqs"

      "transparent_hugepage=madvise"

      "nvme_core.default_ps_max_latency_us=0"

      "module_blacklist=nouveau"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
      "nvidia.NVreg_UsePageAttributeTable=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_EnableGpuFirmware=0"
    ];
    kernelModules = [];
    kernel.sysctl = {
      "vm.page-cluster" = 0;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.dirty_expire_centisecs" = 3000;
      "vm.compaction_proactiveness" = 0;
      "vm.watermark_boost_factor" = 0;
      "vm.min_free_kbytes" = 131072;
      "vm.zone_reclaim_mode" = 0;
      "vm.max_map_count" = 2147483642;

      "kernel.nmi_watchdog" = 0;
      "kernel.sched_autogroup_enabled" = 1;
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "kernel.split_lock_mitigate" = 0;

      "fs.inotify.max_user_watches" = 1048576;
      "fs.inotify.max_user_instances" = 1024;
      "fs.file-max" = 2097152;

      "net.core.netdev_max_backlog" = 16384;
      "net.core.somaxconn" = 8192;
      "net.core.optmem_max" = 65536;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_adv_win_scale" = -2;
      "net.ipv4.tcp_notsent_lowat" = 131072;
    };
  };

  networking = {
    hostName = "sparta";
    firewall = rec {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
  };

  users = {
    users.tudor.extraGroups = [
      "gamemode"
      "wireshark"
    ];
    groups.wireshark = {};
  };

  system.stateVersion = "24.05";

  hardware = {
    cpu.amd.updateMicrocode = true;
    bluetooth.powerOnBoot = false;
    graphics.extraPackages = with pkgs; [
      libva-vdpau-driver
      libvdpau
      libvdpau-va-gl
      vdpauinfo
      libva
      libva-utils
    ];
  };

  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    pipewire = {
      jack.enable = true;
      wireplumber.extraConfig = {
        "10-disable-camera" = {
          "wireplumber.profiles" = {
            main = {
              "monitor.libcamera" = "disabled";
            };
          };
        };
      };
    };
    logind.settings.Login = {
      HandleSuspendKey = "suspend";
      HandleHibernateKey = "suspend";
    };
    irqbalance.enable = true;
    earlyoom = {
      enable = true;
      freeMemThreshold = 5;
      freeSwapThreshold = 10;
      enableNotifications = true;
    };
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';
  };

  systemd = {
    services.bluetooth.wantedBy = lib.mkForce [];
    
    settings.Manager = {
      DefaultTimeoutStartSec = "10s";
      DefaultTimeoutStopSec = "10s";
    };

    sleep.extraConfig = ''
      [Sleep]
      HibernateMode=shutdown
    '';
    services.systemd-suspend.serviceConfig.ExecStartPost = lib.mkForce [
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
  };

  environment = {
    etc."systemd/system-sleep/display-resume" = {
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
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "schedutil";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
    priority = 100;
  };

  security.pam.services.hyprlock = {};

  programs = {
    gamemode = {
      enable = lib.mkForce true;
      enableRenice = true;
      settings = lib.mkForce {
        general = {
          renice = 10;
          softrealtime = "auto";
          ioprio = 0;
          inhibit_screensaver = 1;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };
        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations enabled'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations disabled'";
        };
      };
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };
}
