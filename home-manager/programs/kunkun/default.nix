{pkgs, ...}: let
  kunkunVersion = "0.1.23";
  kunkunGitHub = "https://github.com/kunkunsh/kunkun/releases/download/Kunkun-v0.1.23/kunkun_0.1.23_amd64.AppImage";
  kunkunSHA = "1hc35x3j3ckx28snp6wpmm3pz0gyy1jv6p38plm86s3kd9d11dq5";

  # Build XnViewMP from AppImage
  kunkun = pkgs.appimageTools.wrapType2 {
    name = "kunkun-${kunkunVersion}";
    src = pkgs.fetchurl {
      url = kunkunGitHub;
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
