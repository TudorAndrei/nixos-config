{pkgs, ...}: {
  xdg.configFile."swaync/style.css".text = ''
    /* Dracula Theme */
    @define-color foreground rgb(248, 248, 242);
    @define-color background rgb(40, 42, 54);
    @define-color background-alpha rgba(40, 42, 54, 0.8);
    @define-color accent rgba(189, 147, 249, 0.8);
    @define-color current-line rgb(68, 71, 90);
    @define-color comment rgb(98, 114, 164);

    .notification-row {
      transition: all 200ms ease;
      outline: none;
      margin-bottom: 4px;
      margin-right: 13px;
      margin-top: 8px;
      border-radius: 80px;
    }

    .control-center .notification-row:focus,
    .control-center .notification-row:hover {
      opacity: 1;
      background: transparent;
    }

    .notification-row:focus .notification,
    .notification-row:hover .notification {
      box-shadow: 0 1px 3px 1px rgba(0, 0, 0, 0.5);
      border: 0px solid @accent;
      background: @current-line;
    }

    .control-center .notification {
      box-shadow: none;
    }

    .control-center .notification-row {
      opacity: 0.5;
      margin: -5px;
    }

    .notification {
      transition: all 200ms ease;
      border-radius: 8px;
      margin: 12px 7px 0px 7px;
      box-shadow: 0 1px 3px 1px rgba(0, 0, 0, 0.5);
      padding: 0;
    }

    .notification-content {
      background: transparent;
      padding: 6px;
      border-radius: 8px;
    }

    .close-button {
      background: @current-line;
      color: @foreground;
      text-shadow: none;
      padding: 0;
      border-radius: 100%;
      margin-top: 17px;
      margin-right: 10px;
      box-shadow: none;
      border: none;
      min-width: 24px;
      min-height: 24px;
    }

    .close-button:hover {
      box-shadow: none;
      background: @comment;
      transition: all 0.15s ease-in-out;
      border: none;
    }

    .notification-default-action,
    .notification-action {
      padding: 4px;
      margin: 0;
      box-shadow: none;
      background: @current-line;
      border: 2px solid @accent;
      color: @foreground;
    }

    .notification-default-action:hover,
    .notification-action:hover {
      -gtk-icon-effect: none;
      background: @current-line;
    }

    .notification-default-action {
      border-radius: 8px;
    }

    .notification-default-action:not(:only-child) {
      border-bottom-left-radius: 0px;
      border-bottom-right-radius: 0px;
    }

    .notification-action {
      border-radius: 0px;
      border-top: none;
      border-right: none;
    }

    .notification-action:first-child {
      border-bottom-left-radius: 8px;
    }

    .notification-action:last-child {
      border-bottom-right-radius: 8px;
      border-right: 1px solid @accent;
    }

    .image {
    }

    .body-image {
      margin-top: 6px;
      background-color: @foreground;
      border-radius: 8px;
    }

    .summary {
      font-size: 16px;
      font-weight: bold;
      background: transparent;
      color: @foreground;
      text-shadow: none;
    }

    .time {
      font-size: 16px;
      font-weight: bold;
      background: transparent;
      color: @foreground;
      text-shadow: none;
      margin-right: 18px;
    }

    .body {
      font-size: 15px;
      font-weight: normal;
      background: transparent;
      color: @foreground;
      text-shadow: none;
    }

    .top-action-title {
      color: @foreground;
      text-shadow: none;
    }

    .control-center-clear-all {
      color: @foreground;
      text-shadow: none;
      background: @background;
      border: 2px solid @accent;
      box-shadow: none;
      border-radius: 8px;
    }

    .control-center-clear-all:hover {
      background: @background;
    }

    .control-center-dnd {
      border-radius: 8px;
      background: @background;
      border: 1px solid @accent;
      box-shadow: none;
    }

    .control-center-dnd:checked {
      background: @accent;
    }

    .control-center-dnd slider {
      background: @background;
      border-radius: 8px;
    }

    .control-center {
      background: @background-alpha;
      border-radius: 10px;
      background-clip: border-box;
      padding: 4px;
      box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.3), 0 1px 3px 1px rgba(0, 0, 0, 0.7),
                  0 2px 6px 2px rgba(0, 0, 0, 0.3);
      color: @foreground;
      border: 2px solid @accent;
    }

    .control-center-list {
      background: transparent;
    }

    .floating-notifications {
      background: transparent;
    }

    .blank-window {
      background: transparent;
    }

    .widget-title {
      margin: 8px;
      font-size: 1.5rem;
    }
    .widget-title > button {
      font-size: initial;
      color: @foreground;
      text-shadow: none;
      background: @background;
      border: 2px solid @accent;
      box-shadow: none;
      border-radius: 8px;
    }
    .widget-title > button:hover {
      background: @background;
    }

    .widget-dnd {
      margin: 8px;
      font-size: 1.1rem;
    }
    .widget-dnd > switch {
      font-size: initial;
      border-radius: 8px;
      background: @background;
      border: 1px solid @accent;
      box-shadow: none;
    }
    .widget-dnd > switch:checked {
      background: @accent;
    }
    .widget-dnd > switch slider {
      background: @background;
      border-radius: 8px;
      border: 1px solid @foreground;
    }

    .widget-label {
      margin: 8px;
    }
    .widget-label > label {
      font-size: 1.1rem;
    }

    .widget-mpris {
    }
    .widget-mpris-player {
      padding: 8px;
      margin: 8px;
      background-color: @background;
      border-radius: 8px;
      border: 2px solid @accent;
      color: @foreground;
    }
    .widget-mpris-title {
      font-weight: bold;
      font-size: 1.25rem;
    }
    .widget-mpris-subtitle {
      font-size: 1.1rem;
    }
  '';

  xdg.configFile."swaync/config.json".text = builtins.toJSON {
    "$schema" = "https://raw.githubusercontent.com/ErikReider/SwayNotificationCenter/main/swaync-config-schema.json";
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    control-center-layer = "top";
    layer-shell = true;
    cssPriority = "application";
    control-center-margin-top = 0;
    control-center-margin-bottom = 0;
    control-center-margin-right = 0;
    control-center-margin-left = 0;
    notification-window-width = 500;
    control-center-width = 500;
    control-center-height = 600;
    notification-2fa-action = true;
    notification-inline-replies = false;
    notification-icon-size = 64;
    notification-body-image-size = 64;
    notification-body-image-max-width = 300;
    notification-body-image-max-height = 200;
    timeout = 5;
    timeout-low = 5;
    timeout-critical = 0;
    fit-to-screen = true;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    script-fail-ignore = false;
    widgets = [
      "title"
      "dnd"
      "notifications"
    ];
    widget-config = {
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "Clear All";
      };
      dnd = {
        text = "Do Not Disturb";
      };
      notifications = {
        clear-all-button = true;
        clear-all-button-text = "Clear All";
        list = {
          spacing = 4;
          padding = 0;
          threads = 5;
          history = 100;
        };
      };
    };
  };

  home.packages = with pkgs; [
    swaynotificationcenter
  ];
}
