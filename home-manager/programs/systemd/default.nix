{pkgs, lib, ...}: {
  systemd.user.services.tmux = {
    Unit = {
      Description = "tmux session manager";
      Documentation = "man:tmux(1)";
    };
    Service = {
      Type = "forking";
      Environment = "DISPLAY=:0";
      ExecStart = "${lib.getExe pkgs.tmux} -f ~/.config/tmux/tmux.conf new-session -d";
      ExecStop = "${lib.getExe pkgs.tmux} kill-server";
      RestartSec = 2;
      KillMode = "mixed";
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
