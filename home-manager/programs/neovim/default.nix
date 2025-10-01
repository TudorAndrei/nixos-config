{ pkgs, ... }:

let
  neovim-unwrapped = pkgs.unstable.neovim-unwrapped.overrideAttrs (old: {
    meta =
      old.meta
      or {}
      // {
        maintainers = [];
      };
  });
in
{
  programs.neovim = {
    package = neovim-unwrapped;
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    tree-sitter
  ];
}