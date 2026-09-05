# AGENTS.md

## Project Overview

Personal NixOS and nix-darwin configuration using flakes. Manages system configuration for multiple hosts and user environment via home-manager. Uses Stylix for consistent theming across all applications and sops-nix for secrets management.

## Hosts

### NixOS (x86_64-linux)

- **sparta**: ASUS ROG Strix laptop (AMD Ryzen 9 7945HX + NVIDIA RTX 4080)
- **ark**: MSI Raider laptop (Intel i7-12700H + NVIDIA RTX 3070 Ti)

Both systems run Hyprland (Wayland compositor) with GDM as the display manager.

### nix-darwin (aarch64-darwin)

- **piticu**: MacBook Pro 14-inch (M5, 2025), macOS Tahoe

The darwin host uses Lix as the Nix implementation (`lix-module.darwinModules.default`).

## Package Policy

The same rule holds on every host:

- **mise** installs the CLI tools. The list is `home-manager/shared/mise/config.toml`, which is a live file, thus `mise use -g` writes it and no rebuild is necessary. Never put a CLI that mise carries into a nix package list.
- **nix** installs the GUI applications, the TUI applications like btop, the toolchains, the libraries and the nix tools. On macOS **homebrew** does this part instead (`hosts/modules/homebrew`), because the applications are casks.
- **home-manager** writes the configuration of every program, in `home-manager/shared/`. Only rift, barrs and menuanywhere are macOS-only (`home-manager/macos/`).

This repository is self-contained. No machine needs a second repository.

## Directory Structure

```
/flake.nix              # Main flake with inputs and outputs
/hosts/
  common.nix            # Shared NixOS configuration for all hosts
  common-darwin.nix     # Shared nix-darwin configuration (nix/lix, macOS defaults)
  sparta/               # Host-specific config (hardware, nvidia/asus modules)
  ark/                  # Host-specific config
  piticu/               # Host-specific config (macOS)
  modules/              # Reusable modules (nvidia, asus, homebrew)
/home-manager/
  home.nix              # Home-manager entry point for the NixOS hosts
  darwin.nix            # Home-manager entry point for the macOS host
  shared/               # Modules shared by all hosts (zsh, starship, mise, git, tmux, ghostty, codex, herdr, uv, bun, nvim, agents, secrets)
  macos/                # macOS-only configs (rift, barrs, menuanywhere)
  packages/             # Package lists split by category (cli, dev-tools, gui, darwin, etc.)
  programs/             # Per-program home-manager configurations (Linux hosts)
  nvim/                 # Neovim configuration (LazyVim-based, symlinked to ~/.config/nvim)
/lib/
  theme.nix             # Base16 color scheme and font definitions
/overlays/              # Nixpkgs overlays
/secrets/               # Sops-encrypted secrets (secrets.yaml)
```

## Commands

| Command                                     | Description                                                                |
| ------------------------------------------- | -------------------------------------------------------------------------- |
| `nix flake update`                          | Update all flake inputs                                                    |
| `nos`                                       | Rebuild NixOS configuration (`nh os switch`)                               |
| `nhs`                                       | Rebuild home-manager configuration (`home-manager switch --flake .#tudor`) |
| `sudo darwin-rebuild switch --flake .#piticu` | Rebuild the macOS configuration                                            |

The aliases are defined in `home-manager/shared/zsh.nix`. `nos` and `nhs` exist on the NixOS hosts, `nds` on the macOS host.

## Code Style

- Formatter: **alejandra** (configured in flake.nix)
- Use `let ... in` for local bindings
- Prefer attribute sets over lists when ordering doesn't matter
- No inline comments (user preference)
- Use `lib.getAttrFromPath` for dynamic package lookups from theme definitions

## Adding a New Program

1. Create a new directory under `home-manager/programs/<program-name>/`
2. Add a `default.nix` with the program configuration
3. Import it in `home-manager/home.nix`

Example structure:

```nix
{config, pkgs, ...}: {
  programs.<program> = {
    enable = true;
  };
}
```

## Adding Packages

A CLI goes in `home-manager/shared/mise/config.toml`, on every host. Use `mise use -g <tool>`, which writes that file directly.

The nix package lists in `home-manager/packages/` are for the NixOS hosts, and they hold only what mise does not carry:

- `gui.nix` - Graphical applications
- `media.nix` - Media applications
- `games.nix` - Games
- `system.nix` - System utilities and fonts
- `dev-tools.nix` - Toolchains, libraries, IDEs and the language servers that mise does not have
- `cli.nix` - The few CLI tools that mise does not have
- `darwin.nix` - The nix tools for the macOS host

On macOS the applications come from `hosts/modules/homebrew` instead.

## Theme System

Theme is defined in `lib/theme.nix` using base16 color scheme. Changes here propagate to both NixOS (via Stylix) and home-manager configurations.

Current theme: Dracula-based dark theme with Iosevka NF font.

The shared configs hold their own Dracula colors, thus `stylix.targets.starship` is off, and tmux gets its colors from `home-manager/shared/tmux/extra.conf`.

## Secrets Management

Uses sops-nix with age encryption. Secrets are in `secrets/secrets.yaml`.

Key file location: `~/.config/sops/age/keys.txt`

## Testing Change

Check for evaluation errors before switching:

```bash
nix flake check
```

## Shared Configs

`home-manager/shared/` holds the home-manager modules that all hosts use, thus sparta and piticu stay identical. Every file is generated by nix into the store:

| Module         | Writes                                          | Source of the values             |
| -------------- | ----------------------------------------------- | -------------------------------- |
| `mise.nix`     | installs mise                                   | `pkgs.mise`                      |
| `git.nix`      | `~/.config/git/config`, `~/.config/git/ignore`  | `programs.git`, `git/gitignore_global` |
| `tmux.nix`     | `~/.config/tmux/tmux.conf`                      | `programs.tmux` + `tmux/extra.conf` |
| `zsh.nix`      | `~/.zshrc`                                      | `programs.zsh` + `zsh/init.zsh` and `zsh/{darwin,linux}.zsh` |
| `ghostty.nix`  | `~/.config/ghostty/config`                      | `programs.ghostty.settings`      |
| `agents.nix`   | `~/.claude/CLAUDE.md`, `~/.codex/AGENTS.md`     | `agents/*.md`                    |
| `configs.nix`  | nvim, starship, mise, codex, codex-clean, herdr, uv, bun | out-of-store links to this repository |
| `secrets.nix`  | the sops secrets and templates                  | `secrets/secrets.yaml`           |

Only `home-manager/macos/` is host-specific: rift, barrs and menuanywhere, which exist on macOS only.

Rules:

- `configs.nix` links the files that a tool rewrites or that change often: the mise tool list, starship, nvim, codex, herdr, uv, bun. They are out-of-store links to `~/nixos-config`, thus an edit applies at once and no rebuild is necessary. The mise tool list must stay in this group.
- The other modules generate their files into the store, thus an edit of `git.nix`, `tmux.nix`, `zsh.nix` or `ghostty.nix` needs a rebuild.
- The shared modules do not install the CLI that they configure when mise carries it: starship has no module, and fzf, zoxide and neovim have none either. tmux is the exception. It comes from nix (`programs.tmux`), because its plugins are nix packages too.
- The tmux plugins come from nixpkgs (`programs.tmux.plugins`), not from tpm. `tmux-ssh-split` is a pinned `fetchFromGitHub`, and `amux` comes from the `amux` flake input. Plugin options go in the `extraConfig` of the plugin, because home-manager writes the plugin block before the module `extraConfig`.
- Platform differences live in nix: `git.nix` picks the gpg binary (Homebrew on macOS, nixpkgs on Linux).
- Stylix does not theme starship, tmux or ghostty. The shared configs hold the Dracula colors, thus those three targets are off in `home.nix`.
- This repository is the only source. It lives in `~/nixos-config` on every host, and it never reads a file from outside itself.

## Secrets

`home-manager/shared/secrets.nix` uses sops-nix through the home-manager module, thus one method works on NixOS and on macOS. The module stays inactive while `secrets/secrets.yaml` does not exist.

Bootstrap:

```bash
mkdir -p ~/.config/sops/age
age-keygen -o ~/.config/sops/age/keys.txt
age-keygen -y ~/.config/sops/age/keys.txt
```

Put the public key in `.sops.yaml` in the root of this repository:

```yaml
keys:
  - &tudor age1...
creation_rules:
  - path_regex: secrets/[^/]+\.yaml$
    key_groups:
      - age:
          - *tudor
```

Then `sops secrets/secrets.yaml`, add the values, and rebuild. Each machine needs its own key in `.sops.yaml`, or the same key file copied to `~/.config/sops/age/keys.txt`.

The first secret is `npm_token`. `secrets.nix` renders `~/.npmrc` from it, thus the token never enters this repository, which is public. Rotate the npm token when you put it in sops, because the old value is in the git history of the dotfiles repository.

## Adding Packages on macOS

1. Generic CLI tool: add it to `home-manager/shared/mise/config.toml`, then rebuild.
2. GUI application or macOS-only formula: add it to `hosts/modules/homebrew/default.nix`, then rebuild.
3. Nix-specific tool: add it to `home-manager/packages/darwin.nix`.

`homebrew.onActivation.cleanup = "uninstall"`, thus a rebuild removes the formulae and the casks that the module does not list. A rebuild does not upgrade the Homebrew packages. Use `brew upgrade` for that.

## Adding a macOS-Only Config

Put the file under `home-manager/macos/<program>/`, then add the entry to `home-manager/macos/default.nix`. Use `macos "<program>/<file>"`, which makes an out-of-store symlink to `~/nixos-config`, thus the file stays editable in place and a rebuild is not necessary after an edit. Prefer a home-manager module in `shared/` when both machines use the program.

## Important Notes

- The neovim config (`home-manager/nvim/`) is symlinked to `~/.config/nvim` via `mkOutOfStoreSymlink` for live editing
- Unstable packages are available via `pkgs.unstable.<package>` overlay
- Binary caches are configured for hyprland, nix-community, and other common sources
