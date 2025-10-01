{ pkgs, inputs, system }:
(import ./shared.nix { inherit pkgs; }) ++
(import ./cli.nix { inherit pkgs inputs; }) ++
(import ./gui.nix { inherit pkgs inputs system; }) ++
(import ./media.nix { inherit pkgs inputs system; }) ++
(import ./system.nix { inherit pkgs inputs system; }) ++
(import ./dev-tools.nix { inherit pkgs inputs system; }) ++
(import ./utils.nix { inherit pkgs inputs system; }) ++
(import ./games.nix { inherit pkgs ; })