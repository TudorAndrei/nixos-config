{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode.fhs;
    profiles.default.userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
  };
}
