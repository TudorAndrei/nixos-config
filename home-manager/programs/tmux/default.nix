{pkgs, ...}: let
  tmux-ssh-split = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-ssh-split";
    version = "unstable-2024-10-27";
    src = pkgs.fetchFromGitHub {
      owner = "pschmitt";
      repo = "tmux-ssh-split";
      rev = "4c5f1476fe214a25ecc7d2701e8c08a3a3014d93";
      sha256 = "sha256-KuVHkuF13WZAS3NU0WSaPBZytY78wV0Ti1Va7+LXXoQ=";
    };
  };
in {
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    historyLimit = 100000;
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.prefix-highlight
      tmuxPlugins.yank
      tmuxPlugins.open
      tmuxPlugins.mode-indicator
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = tmux-ssh-split;
        extraConfig = ''
          set-option -ga terminal-overrides ",*:Tc"
        '';
      }
      # {
      # plugin = tmuxPlugins.resurrect;
      # extraConfig = ''
      #   set -g @resurrect-strategy-nvim 'session'
      #   set -g @resurrect-capture-pane-contents 'on'
      #   set -g @resurrect-processes 'ssh'
      # '';
      # }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
    ];
    extraConfig = ''
      bind-key R run-shell ' \
              tmux source-file ~/.config/tmux/tmux.conf > /dev/null; \
              tmux display-message "sourced ~/.config/tmux/tmux.conf"'

      set -g base-index 1
      setw -g pane-base-index 1
      set -g renumber-windows on

      unbind C-b
      set -g prefix C-Space
      unbind r
      set -g mouse on
      bind-key x kill-pane
      set -g detach-on-destroy off

      # Split pane
      unbind %
      unbind '"'
      unbind v
      unbind h

      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"

      # Vim navigation
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'

      # Session management
      bind l display-popup -E "\
          tmux list-sessions -F '#{?session_attached,,#{session_name}}' |\
          sed '/^$/d' |\
          fzf --reverse --header jump-to-session --preview 'tmux capture-pane -pt {}'  |\
          xargs tmux switch-client -t"

      bind Tab switch-client -l

      # Window management
      unbind n
      unbind w
      bind n command-prompt "rename-window '%%'"
      bind w new-window -c "#{pane_current_path}"

      # Vi mode and terminal settings
      set-window-option -g status-keys vi
      set -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'
      set -g focus-events on

      # Status bar styling
      set -g status-interval 0
      set -g status on
      set -g status-justify absolute-centre
      set -g status-left-length 80
      set -g status-right-length 80

      # Stylix color definitions
      BG="#282A36"
      FG="#F8F8F2"
      SELECTION="#44475A"
      COMMENT="#6272A4"
      PURPLE="#BD93F9"

      # Colors and styles
      set -g status-style "fg=$FG,bg=$BG,none"
      set -g pane-border-style "fg=$SELECTION,bg=$BG"
      set -g pane-active-border-style "fg=$COMMENT,bg=$BG"
      set -g display-panes-colour "$COMMENT"
      set -g display-panes-active-colour "$PURPLE"
      setw -g clock-mode-colour "$PURPLE"
      set -g message-style "fg=$FG,bg=$SELECTION"
      set -g message-command-style "fg=$FG,bg=$SELECTION"

      set -g window-status-format "#[fg=$BG,bg=$COMMENT,nobold,noitalics,nounderscore] #[fg=$FG,bg=$COMMENT]#I#[fg=$BACKGROUND,bg=$COMMENT,nobold,noitalics,nounderscore] #[fg=$FG,bg=$COMMENT]#W "
      set -g window-status-current-format "#[fg=$BG,bg=$PURPLE,nobold,noitalics,nounderscore] #[fg=$BG,bg=$PURPLE]#I#[fg=$BACKGROUND,bg=$PURPLE,nobold,noitalics,nounderscore] #[fg=$BG,bg=$PURPLE]#W "
      set -g window-status-separator ""

      set -g status-left "#[fg=$BG,bg=$PURPLE,bold] #S #[fg=$PURPLE,bg=$COMMENT,nobold]"
      set -g status-right "#[fg=$FG,bg=$COMMENT] #H #[fg=$COMMENT,bg=$BG,nobold]#[fg=$COMMENT,bg=$BG]#[fg=$FG,bg=$COMMENT] %Y-%m-%d #[fg=$PURPLE,bg=$COMMENT]#[fg=$BG,bg=$PURPLE,bold] %H:%M "

    '';
  };
}
