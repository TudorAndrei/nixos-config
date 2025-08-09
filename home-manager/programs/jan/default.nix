{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.callPackage ./definition.nix {})
  ];
}