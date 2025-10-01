{ pkgs, inputs, system }:
with pkgs; [
  # Programming languages and runtimes
  go
  nodejs_20
  python3
  lua
  gcc
  stdenv.cc.cc
  zlib
  luajitPackages.luarocks
  
  # Development utilities
  delta
  unstable.bun
  unstable.devenv
  unstable.pnpm
  unstable.claude-code
  fnm
  unstable.uv
  cargo
  nixd
  alejandra
  
  # IDEs and development tools
  unstable.code-cursor-fhs
  unstable.lmstudio
  unstable.postman
  unstable.bruno
  unstable.dbeaver-bin
  
  # Container and virtualization
  distrobox
  unstable.lazydocker
]
