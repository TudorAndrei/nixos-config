{pkgs, inputs, system}:
(import ./cli.nix {inherit pkgs inputs;}) ++
(import ./gui.nix {inherit pkgs;}) ++
(import ./media.nix {inherit pkgs;}) ++
(import ./system.nix {inherit pkgs;}) ++
(import ./dev-tools.nix {inherit pkgs inputs system;}) ++
(import ./games.nix {inherit pkgs;})