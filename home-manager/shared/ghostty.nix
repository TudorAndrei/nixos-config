_: {
  programs.ghostty = {
    enable = true;
    package = null;
    systemd.enable = false;
    settings = {
      font-family = [
        "Ioskeley Mono"
        "JetBrainsMono Nerd Font"
        "Symbols Nerd Font"
      ];
      font-size = 17;
      font-thicken = true;
      font-thicken-strength = 64;
      alpha-blending = "linear-corrected";
      theme = "Dracula";
      working-directory = "home";
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
      confirm-close-surface = false;
      clipboard-read = "allow";
      clipboard-write = "allow";
      clipboard-paste-protection = false;
      app-notifications = "no-clipboard-copy";
      window-decoration = false;
      link-url = true;
      mouse-shift-capture = false;
      shell-integration-features = "ssh-env,ssh-terminfo";
    };
  };
}
