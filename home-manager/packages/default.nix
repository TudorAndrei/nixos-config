{ pkgs }:

(import ./cli.nix { inherit pkgs; }) ++
(import ./gui.nix { inherit pkgs; }) ++
(import ./games.nix { inherit pkgs; })