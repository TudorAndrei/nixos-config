{
  pkgs,
  inputs,
  system,
}:
with pkgs; [
  # Toolchains and libraries
  python3
  gcc
  stdenv.cc.cc
  zlib
  luajitPackages.luarocks

  # Development utilities
  delta
  unstable.devenv
  fnm
  nixd
  alejandra

  # IDEs and development tools
  unstable.code-cursor-fhs
  unstable.zed-editor-fhs
  llm-agents.opencode
  llm-agents.ccusage-opencode
  unstable.lmstudio
  unstable.postman
  unstable.yaak
  unstable.dbeaver-bin

  # Container and virtualization
  distrobox
  docker-buildx
  unstable.antigravity-fhs
  awsume
  kubectl
  granted
  k9s
  awscli2

  # learn
  exercism

  # Language servers and formatters that mise does not carry
  basedpyright
  biome
  docker-compose-language-service
  dockerfile-language-server
  unstable.prettier
  prettierd
]
