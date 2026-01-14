{pkgs}:
with pkgs; [
  # Core system utilities
  wl-clipboard
  alsa-utils
  wget
  curl
  vim
  ripgrep
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

  polychromatic
  # File management
  nautilus
]
