{
  config,
  lib,
  ...
}: let
  tmux = lib.getExe config.programs.tmux.package;
in {
  systemd.user.services.tmux = {
    Unit = {
      Description = "tmux session manager";
      Documentation = "man:tmux(1)";
    };
    Service = {
      Type = "forking";
      Environment = "DISPLAY=:0";
      ExecStart = "${tmux} -f ~/.config/tmux/tmux.conf new-session -d";
      ExecStop = "${tmux} kill-server";
      RestartSec = 2;
      KillMode = "mixed";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
