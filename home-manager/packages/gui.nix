{
  pkgs,
  inputs,
  system,
}: let
in
  with pkgs; [
    unstable.zoom-us
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
