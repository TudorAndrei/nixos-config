{
  inputs,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on && sleep 0.5 && hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        lock_cmd = "hyprlock";
        before_sleep_cmd = "hyprlock";
      };

      listener = [
        {
          timeout = 900;
          on-timeout = "hyprlock";
        }
        {
          timeout = 1200;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;
      };
    };
  };
  wayland = {
    windowManager = {
      hyprland = {
        systemd.enable = true;
        systemd.enableXdgAutostart = true;
        xwayland.enable = true;
        enable = true;
        package = pkgs.hyprland;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
        settings = {
          "$terminal" = "alacritty";
          "$fileManager" = "nautilus";
          "$menu" = "wofi --show drun";
          "$mainMod" = "SUPER";
          env = [
            "XCURSOR_SIZE,24"
            "NVD_BACKEND,direct"
            "HYPRCURSOR_SIZE,50"
          ];
          exec-once = [
            # "waybar"
            "nm-applet"
            "swaync"
            "zen"
            "easyeffects"
            "slack"
            "$terminal --title notes-nvim -e sh -c 'cd /home/tudor/cave/littlebrain && nvim'"
          ];
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            resize_on_border = false;
            allow_tearing = false;

            layout = "dwindle";
          };
          cursor = {
            no_hardware_cursors = true;
          };

          decoration = {
            rounding = 5;
            # Change transparency of focused and unfocused windows
            active_opacity = 1.0;
            inactive_opacity = 1.0;
            # https://wiki.hyprland.org/Configuring/Variables/#blur
            blur = {
              enabled = false;
            };
            shadow = {
              enabled = false;
            };
          };
          misc = {
            vfr = true;
          };
          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
          animations = {
            enabled = false;
          };
          dwindle = {
            pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
            preserve_split = true; # You probably want this
          };
          master = {
            new_status = "master";
          };
          input = {
            kb_layout = "us";
            kb_variant = "";
            kb_model = "";
            kb_options = "";
            kb_rules = "";
            follow_mouse = 1;
            sensitivity = 0;
            touchpad = {
              natural_scroll = true;
              scroll_factor = 0.2;
            };
          };

          windowrulev2 = [
            "workspace 1, class:^zen-alpha$"
            "workspace 7, class:^steam$"
            # Slack floating popup - must come before general chat rules
            "float, class:^Slack$"
            "center, class:^Slack$"
            "workspace special:slack, class:^Slack$"
            # chat
            "workspace 9, class:^signal$"
            "workspace 9, class:^Signal$"
            "workspace 9, class:^discord$"
            "workspace 9, class:^veskop$"
            # resaerch
            "workspace 4, class:^Zotero$"
            # music
            "workspace 10, class:com.github.wwmm.easyeffects"
            "workspace 10, class:spotify"
            "workspace 10, class:^org.strawberrymusicplayer.strawberry$"
            "suppressevent maximize, class:.*"
            "workspace special:notes, class:^Alacritty$, title:^notes-nvim$"
          ];

          layerrule = [
            "blur, vicinae"
            "ignorealpha 0.79, vicinae"
            "animation slide, vicinae"
          ];

          bind = [
            "$mainMod, Return, exec, $terminal"
            "$mainMod_SHIFT, Q, killactive,"
            "$mainMod, D, exec, $menu"
            "$mainMod, E, exec, $fileManager"
            "$mainMod, F, fullscreen"

            "$mainMod_SHIFT, H, movewindow, l"
            "$mainMod_SHIFT, L, movewindow, r"
            "$mainMod_SHIFT, K, movewindow, u"
            "$mainMod_SHIFT, J, movewindow, d"

            "$mainMod, h, movefocus, l"
            "$mainMod, l, movefocus, r"
            "$mainMod, k, movefocus, u"
            "$mainMod, j, movefocus, d"

            "$mainMod, 1, workspace, 1"
            "$mainMod, 2, workspace, 2"
            "$mainMod, 3, workspace, 3"
            "$mainMod, 4, workspace, 4"
            "$mainMod, 5, workspace, 5"
            "$mainMod, 6, workspace, 6"
            "$mainMod, 7, workspace, 7"
            "$mainMod, 8, workspace, 8"
            "$mainMod, 9, workspace, 9"
            "$mainMod, 0, workspace, 10"
            "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
            "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
            "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
            "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
            "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
            "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
            "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
            "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
            "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
            "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
            "$mainMod, S, togglespecialworkspace, magic"
            "$mainMod SHIFT, S, movetoworkspace, special:magic"
            "$mainMod SHIFT, comma, movecurrentworkspacetomonitor, l"
            "$mainMod SHIFT, period, movecurrentworkspacetomonitor, r"
            "$mainMod SHIFT, F, togglefloating,"
            "$mainMod,p, exec, grimblast  copysave active"
            "$mainMod SHIFT,p, exec, grimblast  copysave area"
            "$mainMod ALT,p, exec, grimblast copysave output"
            "$mainMod CTRL,p, exec, grimblast copysave screen"
            "$mainMod, N, togglespecialworkspace, notes"
            "$mainMod SHIFT, N, movetoworkspacesilent, special:notes"
            "$mainMod, V, exec, wireguard-ui"
            "$mainMod, C, togglespecialworkspace, slack"
          ];
          bindel = [
            ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
            ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
          ];
          bindl = [
            ", XF86AudioNext, exec, playerctl next"
            ", XF86AudioPause, exec, playerctl play-pause"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
          ];
          bindm = [
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    wofi
    grimblast
    hyprshot
    hyprpicker
    hyprcursor
    hyprpaper
  ];
}
