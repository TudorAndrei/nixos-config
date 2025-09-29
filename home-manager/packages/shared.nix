{pkgs, ...}:
with pkgs; [
  # Core utilities (moved from systemPackages to avoid duplication)
  wl-clipboard
  alsa-utils
  wget
  curl
  vim
  ripgrep
  fd
  tree
  killall

  # Development tools
  go
  nodejs_20
  python3
  lua
  gcc
  stdenv.cc.cc
  zlib
  luajitPackages.luarocks

  # System utilities
  font-awesome
  ghostscript
  graphviz
  ffmpeg
  icu.dev
  nvitop
  htop-vim
  gnome-disk-utility

  # Hyprland utilities
  hyprpicker
  hyprcursor
  hyprpaper
  hyprshot

  # File management
  nautilus
  gnome-disk-utility
]
