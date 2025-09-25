{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.callPackage ./cursor-cli-package.nix {})
  ];
}
