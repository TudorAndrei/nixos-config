{pkgs, ...}: let
  razer-battery-script = pkgs.writeShellScript "razer-battery" ''
    battery=$(${pkgs.python3Packages.openrazer}/bin/python3 -c '
from openrazer.client import DeviceManager
import json

dm = DeviceManager()
for device in dm.devices:
    if device.has("battery"):
        level = device.battery_level
        charging = device.is_charging
        icon = "󱊦" if charging else ("󰁹" if level > 80 else "󰁾" if level > 60 else "󰁽" if level > 40 else "󰁻" if level > 20 else "󰁺")
        status_class = "charging" if charging else ("low" if level < 20 else "")
        tooltip = f"{device.name}: {level}%" + (" (charging)" if charging else "")
        print(json.dumps({"text": f"{icon} {level}%", "tooltip": tooltip, "class": status_class}))
        break
else:
    print(json.dumps({"text": "", "tooltip": "No Razer device with battery found"}))
' 2>/dev/null || echo '{"text": "", "tooltip": "OpenRazer not available"}')
    echo "$battery"
  '';
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    settings = {
      mainBar = {
        layer = "top";
        spacing = 10;
        position = "top";
        # mode": "dock",
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 0;
        modules-left = ["hyprland/workspaces"];
        modules-center = [
          "clock#calendar"
          "custom/separator"
          "clock#time"
          "custom/separator"
          "custom/weather"
        ];
        modules-right = [
          "tray"
          "custom/notification"
          "bluetooth"
          "network"
          "memory"
          "disk"
          "cpu"
          "temperature"
          "pulseaudio"
          "custom/razer-battery"
          "battery"
        ];
        "hyprland/workspaces" = {
          all-output = true;
          sort-by-number = true;
          format = "{icon}";
          format-icons = {
            "1" = "1: ";
            "2" = "2: ";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9: ";
            "10" = "0: ";
            urgent = "";
            focused = "";
            default = "";
            special = "";
            "special:slack" = "";
            "special:notes" = "";
          };
          show-special = true;
        };
        "clock#time" = {
          format = "{:%I:%M %p}";
        };
        "custom/separator" = {
          format = " | ";
          tooltip = false;
        };
        "custom/separator_dot" = {
          format = "•";
          tooltip = false;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-full = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          # // "format-good": "", // An empty format will hide the module
          # // "format-full": "",
          # // "format-icons": [ "", "", "", "", "" ]
        };
        "clock#calendar" = {
          format = "{:%F}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "cpu" = {
          interval = 10;
          format = " {}%";
          max-length = 10;
        };
        "disk" = {
          interval = 30;
          format = " {free}";
          path = "/";
        };
        "memory" = {
          interval = 30;
          format = " {percentage}%";
          max-length = 10;
        };
        "clock2" = {
          format = "<b>󰥔 {:%I:%M 󰃭 %d/%m}</b>";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "temperature" = {
          # // "thermal-zone": 2,
          # // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
          critical-threshold = 80;
          # // "format-critical": "{temperatureC}°C ",
          format = "{temperatureC}°C ";
        };
        "bluetooth" = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱 {num_connections}";
          # format-connected-battery = "󰂱 {device_alias} (󰥉 {device_battery_percentage}%)";
          # // "format-device-preference": [ "device1", "device2" ], // preference list deciding the displayed device
          tooltip-format = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected";
          tooltip-format-disabled = "bluetooth off";
          tooltip-format-connected = "{controller_alias}\t{controller_address} ({status})\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t({device_battery_percentage}%)";
          max-length = 35;
          on-click = "blueman-manager";
        };
        "network" = {
          format = "󰤭 ";
          format-wifi = "{icon} ({signalStrength}%)";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-disconnected = "󰤫 Disconnected";
          tooltip-format = "wifi <span color='#ee99a0'>off</span>";
          tooltip-format-wifi = "SSID: {essid}({signalStrength}%), {frequency} MHz\nInterface: {ifname}\nIP: {ipaddr}\nGW: {gwaddr}\n\n<span color='#a6da95'>{bandwidthUpBits}</span>\t<span color='#ee99a0'>{bandwidthDownBits}</span>\t<span color='#c6a0f6'>󰹹{bandwidthTotalBits}</span>";
          tooltip-format-disconnected = "<span color='#ed8796'>disconnected</span>";
          format-ethernet = "󰈀 {ipaddr}/{cidr}";
          format-linked = "󰈀 {ifname} (No IP)";
          max-length = 35;
          on-click = "nm-connection-editor";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{volume}% {icon}";
          tooltip = false;
          format-muted = " Muted";
          on-click = "pavucontrol";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          ignored-sinks = ["Easy Effects Sink"];
        };
        tray = {
          icon-size = 14;
          tooltip = false;
          spacing = 10;
        };
        "custom/weather" = {
          format = "{}°";
          tooltip = true;
          interval = 3600;
          exec = "wttrbar --location Bucharest";
          return-type = "json";
        };
        "custom/razer-battery" = {
          format = "{}";
          return-type = "json";
          interval = 60;
          exec = "${razer-battery-script}";
          exec-if = "pgrep -x openrazer-daem";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            "notification" = "󰂢<span foreground='red'><sup>󰄀</sup></span>";
            "none" = "󰂢";
            "dnd-notification" = "󰇷<span foreground='red'><sup>󰄀</sup></span>";
            "dnd-none" = "󰇷";
            "inhibited-notification" = "󰂢<span foreground='red'><sup>󰄀</sup></span>";
            "inhibited-none" = "󰂢";
            "dnd-inhibited-notification" = "󰇷<span foreground='red'><sup>󰄀</sup></span>";
            "dnd-inhibited-none" = "󰇷";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          exec = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          escape = true;
        };
      };
    };
    style = ''
      @define-color background-darker #1e1f29;
      @define-color background #282a36;
      @define-color selection #44475a;
      @define-color foreground #f8f8f2;
      @define-color comment #6272a4;
      @define-color cyan #8be9fd;
      @define-color green #50fa7b;
      @define-color orange #ffb86c;
      @define-color pink #ff79c6;
      @define-color purple #bd93f9;
      @define-color red #ff5555;
      @define-color yellow #f1fa8c;
      * {
          font-family: 'Iosevka NF';
          border: none;
          border-radius: 0;
          font-size: 11pt;
          min-height: 0;
      }
      window#waybar {
          background: @background-darker;
          color: @foreground;
          border-bottom: 2px solid @background;
      }
      #workspaces button {
          padding: 0 10px;
          background: @background;
          color: @foreground;
      }
      #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
          background-image: linear-gradient(0deg, @selection, @background-darker);
      }
      #workspaces button.active {
          background-image: linear-gradient(0deg, @purple, @selection);
      }
      #workspaces button.urgent {
          background-image: linear-gradient(0deg, @red, @background-darker);
      }
      #taskbar button.active {
          background-image: linear-gradient(0deg, @selection, @background-darker);
      }
      #clock {
          padding: 0 4px;
          background: @background;
      }
    '';
  };

  home.packages = with pkgs; [
    wttrbar
    networkmanagerapplet
  ];
}
