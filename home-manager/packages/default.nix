{ pkgs, inputs, system }:
(import ./cli.nix { inherit pkgs inputs; }) ++
(import ./gui.nix { inherit pkgs inputs system; }) ++
(import ./games.nix { inherit pkgs ; })