# Updating

[Standard Config](https://github.com/Misterio77/nix-starter-configs/tree/main/standard)

## NixOS (sparta, ark)

```bash
nix flake update
nos
nhs
```

## macOS (piticu)

This host is for a fresh machine. Order of the first installation:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
curl -sSf -L https://install.lix.systems/lix | sh -s -- install
git clone git@github.com:TudorAndrei/nixos-config.git ~/nixos-config
nix run nix-darwin/nix-darwin-25.11#darwin-rebuild -- switch --flake ~/nixos-config#piticu
```

Homebrew and Lix must be there first, because nix-darwin declares the formulae
and the casks but does not install Homebrew, and the flake uses Lix.

This repository goes to `~/nixos-config`, the same place as on the NixOS hosts,
and it is the only thing the machine needs. Nothing reads any other repository.

Later:

```bash
nix flake update
sudo darwin-rebuild switch --flake ~/nixos-config#piticu
```

After the first rebuild on any host, install the CLI tools:

```bash
mise install
```

## Shared configs

`home-manager/shared/` holds every program that sparta and piticu both use:
zsh, starship, mise, ghostty, tmux, git, nvim, codex, herdr, uv, bun, the agent
instructions and the sops secrets. Only rift, barrs and menuanywhere are
macOS-only, in `home-manager/macos/`. See AGENTS.md for the details, and for
the sops bootstrap.

Package policy, the same on every host:

- CLI tools: mise. Nix installs mise itself, the tool list is
  `home-manager/shared/mise/config.toml`, and `mise use -g` writes that file
  with no rebuild.
- Applications, toolchains and libraries: nix on the NixOS hosts
  (`home-manager/packages/`), homebrew on macOS (`hosts/modules/homebrew`).
- Nix tools (nixd, alejandra, nh, sops, age): nix, because mise does not carry
  them.
- macOS-only configs (rift, barrs, menuanywhere): `home-manager/macos/`
- The npm token comes from sops (`home-manager/shared/secrets.nix`)
