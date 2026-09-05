{
  pkgs,
  outputs,
  ...
}: {
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes" "ca-derivations"];
    trusted-users = ["root" "tudor"];
    substituters = [
      "https://cache.nixos.org/?priority=5"
      "https://cache.lix.systems?priority=10"
      "https://nix-community.cachix.org?priority=20"
      "https://cache.numtide.com?priority=35"
    ];
    trusted-substituters = [
      "https://cache.lix.systems"
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlJezaZlrBWkDsspoQ="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
    max-jobs = "auto";
    cores = 0;
  };

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    interval = [
      {
        Weekday = 7;
        Hour = 3;
        Minute = 0;
      }
    ];
    options = "--delete-older-than 7d";
  };

  programs.zsh.enable = true;
  environment.shells = [pkgs.zsh];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  system.stateVersion = 6;

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 1000000.0;
      autohide-time-modifier = 0.0;
      tilesize = 1;
      orientation = "bottom";
      show-recents = false;
      persistent-apps = [];
      persistent-others = [];
    };
    NSGlobalDomain._HIHideMenuBar = false;
    CustomUserPreferences = {
      NSGlobalDomain = {
        CGDisableCursorLocationMagnification = true;
        AppleMenuBarVisibleInFullscreen = true;
      };
      "com.apple.dock".no-bouncing = true;
      "com.apple.controlcenter"."NSStatusItem Visible AutoHide" = false;
    };
  };
}
