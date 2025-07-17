{
  lib,
  appimageTools,
  fetchurl,
}: let
  pname = "jan";
  version = "0.6.0";
  src = fetchurl {
    url = "https://github.com/menloresearch/jan/releases/download/v${version}/Jan_${version}_amd64.AppImage";
    # https://github.com/menloresearch/jan/releases/download/v0.6.0/Jan_0.6.0_amd64.AppImage
    hash = "sha256-yKveu2hOgGxd+YDVTC8SYRtkHlyvr2Nxj2cFkOmQZCs=";
  };
  # appimageContents = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    # extraInstallCommands = ''
    #   install -Dm444 ${appimageContents}/jan.desktop -t $out/share/applications
    #   substituteInPlace $out/share/applications/jan.desktop \
    #     --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=jan'
    #   cp -r ${appimageContents}/usr/share/icons $out/share
    # '';

    meta = {
      changelog = "https://github.com/janhq/jan/releases/tag/v${version}";
      description = "Jan is an open source alternative to ChatGPT that runs 100% offline on your computer";
      homepage = "https://github.com/janhq/jan";
      license = lib.licenses.agpl3Plus;
      mainProgram = "jan";
      maintainers = [];
      platforms = with lib.systems.inspect; patternLogicalAnd patterns.isLinux patterns.isx86_64;
    };
  }
