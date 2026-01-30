# AGENTS.md

## Project Overview

Personal NixOS configuration using flakes. Manages system configuration for multiple hosts and user environment via home-manager. Uses Stylix for consistent theming across all applications and sops-nix for secrets management.

## Hosts

- **sparta**: ASUS ROG Strix laptop (AMD Ryzen 9 7945HX + NVIDIA RTX 4080)
- **ark**: MSI Raider laptop (Intel i7-12700H + NVIDIA RTX 3070 Ti)

Both systems run Hyprland (Wayland compositor) with GDM as the display manager.

## Directory Structure

```
/flake.nix              # Main flake with inputs and outputs
/hosts/
  common.nix            # Shared NixOS configuration for all hosts
  sparta/               # Host-specific config (hardware, nvidia/asus modules)
  ark/                  # Host-specific config
  modules/              # Reusable NixOS modules (nvidia, asus)
/home-manager/
  home.nix              # Main home-manager entry point
  packages/             # Package lists split by category (cli, dev-tools, gui, etc.)
  programs/             # Per-program home-manager configurations
  nvim/                 # Neovim configuration (LazyVim-based, symlinked to ~/.config/nvim)
/lib/
  theme.nix             # Base16 color scheme and font definitions
/overlays/              # Nixpkgs overlays
/secrets/               # Sops-encrypted secrets (secrets.yaml)
```

## Commands

| Command            | Description                                                                |
| ------------------ | -------------------------------------------------------------------------- |
| `nix flake update` | Update all flake inputs                                                    |
| `nos`              | Rebuild NixOS configuration (`nh os switch`)                               |
| `nhs`              | Rebuild home-manager configuration (`home-manager switch --flake .#tudor`) |

The `nos` and `nhs` aliases are defined in `home-manager/programs/zsh/default.nix`.

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

Packages are organized in `home-manager/packages/`:

- `cli.nix` - Command-line utilities
- `dev-tools.nix` - Development tools
- `gui.nix` - Graphical applications
- `games.nix` - Games
- `media.nix` - Media applications
- `system.nix` - System utilities

Add packages to the appropriate file as items in the list.

## Theme System

Theme is defined in `lib/theme.nix` using base16 color scheme. Changes here propagate to both NixOS (via Stylix) and home-manager configurations.

Current theme: Dracula-based dark theme with Iosevka NF font.

## Secrets Management

Uses sops-nix with age encryption. Secrets are in `secrets/secrets.yaml`.

Key file location: `~/.config/sops/age/keys.txt`

## Testing Change

Check for evaluation errors before switching:

```bash
nix flake check
```

## Important Notes

- The neovim config (`home-manager/nvim/`) is symlinked to `~/.config/nvim` via `mkOutOfStoreSymlink` for live editing
- Unstable packages are available via `pkgs.unstable.<package>` overlay
- Binary caches are configured for hyprland, nix-community, and other common sources
