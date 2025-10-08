{
  pkgs,
  inputs,
  system,
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
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
    ianny
  ]
