{pkgs, ...}:
with pkgs; let
  R-custom = rWrapper.override {packages = with rPackages; [rmarkdown];};
in {
  home.packages = [
    R-custom
  ];
}
