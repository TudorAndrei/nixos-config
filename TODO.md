### Detailed Recommendations

#### 1. Home-Manager Configuration (`home-manager/`)
- [ ] **Refactor Package List:** Create a `home-manager/packages/` directory, split the package list into categorized files, and import them into `home.nix`.
- [ ] **Modularize Inline Programs:** Move configurations for `git`, `zsh`, `fzf`, etc., from `home.nix` into their own modules in `home-manager/programs/`.
- [ ] **Externalize Scripts:** Move the `update-system` script from `home.nix` to a separate `.sh` file and link it via `source`.

#### 2. NixOS Host Configurations (`hosts/`)
- [ ] **Centralize NVIDIA Settings:** Move common `hardware.nvidia` settings and the `nvidia-vaapi-driver` package to `hosts/common.nix`.
- [ ] **Create `nvidia-offload` Module:** Convert the `nvidia-offload` script into a dedicated NixOS module.
- [ ] **(Optional) Create `asus` Module:** Group ASUS-specific services into a new `asus` module.
- [ ] **Remove Redundancy:** Delete the redundant `extraGroups` definition from `hosts/ark/configuration.nix`.

#### 3. Custom Packages & Overlays (`pkgs/` & `overlays/`)
- [x] **Consolidate Custom Packages:** Move all custom package definitions (`jan`, `opencode`, `llm` components) into the `pkgs/` directory.
- [x] **Activate `pkgs` Directory:** Update `pkgs/default.nix` to import all consolidated packages, making them globally available via the `additions` overlay.