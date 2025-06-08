{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode.fhs;
    userSettings = builtins.fromJSON (builtins.readFile ./settings.json);
  };
}
