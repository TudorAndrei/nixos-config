{pkgs, ...}: let
  kunkunVersion = "0.1.37";
  kunkunSHA = "1hc35x3j3ckx28snp6wpmm3pz0gyy1jv6p38plm86s3kd9d11dq5";

  kunkun = pkgs.appimageTools.wrapType2 {
    name = "kunkun-${kunkunVersion}";
    src = pkgs.fetchurl {
      url = "https://github.com/kunkunsh/kunkun/releases/download/Kunkun-v${kunkunVersion}/kunkun_${kunkunVersion}_amd64.AppImage";
      sha256 = "${kunkunSHA}";
    };
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/kunkun.desktop <<EOF
      [Desktop Entry]
      Type=Application
      Name=Kunkun
      Exec=kunkun-${kunkunVersion} %F
      Categories=Launcher;
      EOF
    '';
  };
in {
  home.packages = [
    kunkun
  ];
}
