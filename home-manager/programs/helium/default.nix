{pkgs, ...}: let
  pname = "helium-browser";
  version = "0.6.7.1";
  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    hash = "sha256-fZTBNhaDk5EeYcxZDJ83tweMZqtEhd7ws8AFUcHjFLs=";
  };
  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version src;
  };
  helium = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/helium.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/helium.desktop \
        --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      install -Dm444 ${appimageContents}/helium.png -t $out/share/pixmaps/helium.png
    '';

    meta = {
      description = "Helium web browser";
      homepage = "https://github.com/imputnet/helium-linux";
      platforms = ["x86_64-linux"];
      mainProgram = pname;
    };
  };
in {
  home.packages = [helium];
}
