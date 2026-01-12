{
  pkgs,
  inputs,
  system,
}:
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
  claude-code
  fnm
  unstable.uv
  cargo
  nixd
  alejandra

  # IDEs and development tools
  inputs.cursor.packages.${system}.cursor
  inputs.opencode.packages.${system}.default
  unstable.lmstudio
  unstable.postman
  unstable.yaak
  unstable.dbeaver-bin

  # Container and virtualization
  distrobox
  unstable.lazydocker
  docker-buildx
  awsume
  k9s
  awscli2

  # learn
  exercism

  # Neovim LSP servers and formatters
  basedpyright
  hadolint
  unstable.vscode-json-languageserver
  lua-language-server
  docker-compose-language-service
  dockerfile-language-server
  djlint
  biome
  rustywind
  jinja-lsp
  marksman
  stylua
  selene
  taplo
  rust-analyzer
  tailwindcss-language-server
  unstable.prettier
  prettierd
  yamlfmt
  markdownlint-cli2
]
