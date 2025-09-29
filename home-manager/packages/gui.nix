{
  pkgs,
  inputs,
  system,
}:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
with pkgs; [
  nwg-displays
  unstable.lmstudio
  unstable.code-cursor-fhs
  wireguard-tools
  unstable.wireguard-ui
  # google-chrome
  unstable.postman
  slack
  swaynotificationcenter
  vlc
  signal-desktop
  libreoffice
  qbittorrent-enhanced
  unstable.zotero
  localsend
  czkawka
  foliate
  unstable.bruno
  pika-backup
  stremio
  libsForQt5.okular
  obsidian
  strawberry
  mpv
  pavucontrol
  unstable.dbeaver-bin
  networkmanagerapplet
  inputs.vicinae.packages.${system}.default
]
