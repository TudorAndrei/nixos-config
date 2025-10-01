{
  pkgs,
  inputs,
}:
with pkgs; [
  # CLI-specific tools
  fd
  tree
  zip
  unzip
  hyperfine
  brightnessctl
  feh
  pamixer
  fastfetch
  eza
  dust
  slurp
  jq
  pandoc
  scrcpy
  libnotify
]
