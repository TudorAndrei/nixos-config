{ pkgs, inputs, system }:
with pkgs; [
  # Core system utilities
  wl-clipboard
  alsa-utils
  wget
  curl
  vim
  ripgrep
  fd
  tree
  killall
  
  # System monitoring and management
  nvitop
  htop-vim
  gnome-disk-utility
  
  # Fonts and graphics
  font-awesome
  ghostscript
  graphviz
  ffmpeg
  icu.dev
  
  # File management
  nautilus
]
