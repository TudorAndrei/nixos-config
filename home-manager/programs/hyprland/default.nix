{...}: {
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$terminal" = "alacritty";
    "$fileManager" = "nautilus";
    "$menu" = "wofi --show drun";
    "$mainMod" = "SUPER";
    monitor = [
      "eDP-1, 2560x1440@240.00Hz, 0x0, 1"
      "eDP-2, 2560x1440@240.00Hz, 0x0, 1"
    ];
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];
    exec-once = [
      "nm-applet"
      "waybar"
      "hyprpaper "
      "firefox"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;


      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 10;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;


      # https://wiki.hyprland.org/Configuring/Variables/#blur
      blur = {
        enabled = false;
      };
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

    gestures = {
      workspace_swipe = false;
    };
    windowrulev2 = [
      "workspace 1, class:(firefox)"
      "workspace 1, title:(Spotify), initialTitle:(Spotify)"
      "workspace 7,  class:(steam)"
      "workspace 9,  class:(signal), class:(discord)"
      "suppressevent maximize, class:.*"
    ];

    bind = [
      "$mainMod, Return, exec, $terminal"
      "$mainMod_SHIFT, Q, killactive,"
      "$mainMod, M, exit,"
      "$mainMod, E, exec, $fileManager"

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
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
      "$mainMod SHIFT, comma, movecurrentworkspacetomonitor, l"
      "$mainMod SHIFT, period, movecurrentworkspacetomonitor, r"
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
  };
}