{
  pkgs,
  inputs,
  system,
}: let
in
  with pkgs; [
    wireguard-tools
    unstable.wireguard-ui
    # google-chrome
    slack
    signal-desktop
    libreoffice
    localsend
    czkawka
    pika-backup
    libsForQt5.okular
    obsidian
    pavucontrol
  ]
