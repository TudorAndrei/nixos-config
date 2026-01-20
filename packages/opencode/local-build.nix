# This file serves as a wrapper to build OpenCode from the local repository
{ 
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,
}:

let
  # Get the actual flake outputs from the cloned repository
  outputs = (import ./. { });
  
  # Get the package for the current system
  opencode = outputs.packages.${system}.default;
in
{
  default = opencode;
  desktop = outputs.packages.${system}.desktop;
}