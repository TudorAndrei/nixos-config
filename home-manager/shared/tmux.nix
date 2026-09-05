{
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (pkgs) tmuxPlugins;

  tmux-ssh-split = tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-ssh-split";
    version = "unstable-2024-10-27";
    src = pkgs.fetchFromGitHub {
      owner = "pschmitt";
      repo = "tmux-ssh-split";
      rev = "4c5f1476fe214a25ecc7d2701e8c08a3a3014d93";
      sha256 = "sha256-KuVHkuF13WZAS3NU0WSaPBZytY78wV0Ti1Va7+LXXoQ=";
    };
  };

  amux = tmuxPlugins.mkTmuxPlugin {
    pluginName = "amux";
    version = inputs.amux.shortRev or "unstable";
    src = inputs.amux;
  };

  sshSplit = "${tmux-ssh-split}/share/tmux-plugins/tmux-ssh-split/scripts/tmux-ssh-split.sh";
  resurrectScripts = "${tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts";

  worktreeSessionPicker =
    pkgs.writeShellScript "worktree-session-picker"
    (builtins.readFile ./tmux/worktree-session-picker.sh);
in {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    mouse = true;
    focusEvents = true;
    escapeTime = 0;
    baseIndex = 1;
    historyLimit = 100000;
    prefix = "C-Space";
    plugins = [
      tmuxPlugins.sensible
      tmuxPlugins.yank
      tmuxPlugins.open
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmux-ssh-split;
        extraConfig = ''
          set -g @ssh-split-h-key "v"
          set -g @ssh-split-v-key "h"
          set -g @ssh-split-w-key "c"
          set -g @ssh-split-keep-cwd "true"
          set -g @ssh-split-keep-remote-cwd "true"
          set -g @ssh-split-strip-cmd "true"
          set -g @ssh-split-fail "false"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes 'ssh'
          set -g @resurrect-save-bash-history 'on'
          set -g @resurrect-save-shell-history 'on'
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-vi 'session'
          set -g @resurrect-dir '~/.local/state/tmux/resurrect'
          set -g @resurrect-delete-backup-after '2'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '15'
        '';
      }
      {
        plugin = amux;
        extraConfig = ''
          set -g @amux-status off
          set -g @amux-picker-key "l"
        '';
      }
    ];

    extraConfig =
      builtins.readFile ./tmux/extra.conf
      + ''

        bind L display-popup -E -d "#{pane_current_path}" "${worktreeSessionPicker}"

        bind-key C-s run-shell -b 'tmux display-message "Saving session..." && ${resurrectScripts}/save.sh'
        bind-key C-r run-shell -b 'tmux display-message "Restoring session..." && ${resurrectScripts}/restore.sh'

        bind-key v run-shell "TMUX_PANE='#{pane_id}' ${sshSplit} -c '#{pane_current_path}' --keep-remote-cwd --strip-cmd -h"
        bind-key h run-shell "TMUX_PANE='#{pane_id}' ${sshSplit} -c '#{pane_current_path}' --keep-remote-cwd --strip-cmd -v"
        bind-key c run-shell "TMUX_PANE='#{pane_id}' ${sshSplit} -c '#{pane_current_path}' --keep-remote-cwd --strip-cmd --window"
      '';
  };

  home.activation.tmuxResurrectDirectory = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p "$HOME/.local/state/tmux/resurrect"
  '';
}
