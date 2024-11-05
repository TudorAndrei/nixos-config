{
  pkgs,
  config,
  ...
}: let
  tmux-ssh-split =
    pkgs.tmuxPlugins.mkTmuxPlugin
    {
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
    terminal = "screen-256color";
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

            # set-option -g @ssh-split-keep-cwd "true"
            # set-option -g @ssh-split-fail "false"
            # set-option -g @ssh-split-no-shell "false"
            # # set-option -g @ssh-split-strip-cmd "true"
            # set-option -g @ssh-split-verbose "false"
            # set-option -g @ssh-split-h-key "h"
            # set-option -g @ssh-split-v-key "v"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''

          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-processes 'ssh'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '1'
        '';
      }
    ];
    extraConfig = ''
      BACKGROUND="#${config.lib.stylix.colors.base00}"
      SELCTION="#${config.lib.stylix.colors.base02}"
      COMMENT="#${config.lib.stylix.colors.base03}"

      set -g base-index 1           # start windows numbering at 1
      setw -g pane-base-index 1     # make pane numbering consistent with windows

      set -g renumber-windows on    # renumber windows when a window is closed

      unbind C-b
      set -g prefix C-Space
      unbind r
      set -g mouse on
      bind-key x kill-pane
      set -g detach-on-destroy off

      # Split pane
      unbind % # Split vertically
      unbind '"' # Split horizontally
      unbind v
      unbind h

      bind v split-window -h -c "#{pane_current_path}"
      bind h split-window -v -c "#{pane_current_path}"


      # decide whether we're in a Vim process
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'select-pane -R'


      # fzf session selector
      bind l display-popup -E "\
          tmux list-sessions -F '#{?session_attached,,#{session_name}}' |\
          sed '/^$/d' |\
          fzf --reverse --header jump-to-session --preview 'tmux capture-pane -pt {}'  |\
          xargs tmux switch-client -t"

      # move to last session
      bind Tab switch-client -l

      # Cycle panes

      unbind n  #DEFAULT KEY: Move to next window
      unbind w  #DEFAULT KEY: change current window interactively
      bind n command-prompt "rename-window '%%'" # rename window
      bind w new-window -c "#{pane_current_path}" # make new window

      # Vi mode
      set-window-option -g status-keys vi

      # Neovim fix cursor
      set -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      set -g focus-events on
      set -g status-justify absolute-centre

      # DRACULA
      set -g status-interval 0
      set -g status on
      set -g status-left-length 80
      set -g status-right-length 80
      set -g status-style "fg=brightwhite, bg=$BACKGROUND,none"
      set -g pane-border-style "fg=$SELECTION, bg=$BACKGROUND"
      set -g pane-active-border-style "fg=$COMMENT, bg=$BACKGROUND"
      set -g display-panes-colour black
      set -g display-panes-active-colour brightblack
      setw -g clock-mode-colour blue
      set -g message-style "fg=brightwhite, bg=$COMMENT"
      set -g message-command-style "fg=brightwhite, bg=$COMMENT"

      # Window format
      set -g window-status-format "#[fg=$BACKGROUND,bg=$COMMENT,nobold,noitalics,nounderscore] #[fg=brightwhite,bg=$COMMENT]#I#[fg=$BACKGROUND,bg=$COMMENT,nobold,noitalics,nounderscore] #[fg=brightwhite,bg=$COMMENT]#W "
      set -g window-status-current-format "#[fg=$BACKGROUND,bg=blue,nobold,noitalics,nounderscore] #[fg=$BACKGROUND,bg=blue]#I#[fg=$BACKGROUND,bg=blue,nobold,noitalics,nounderscore] #[fg=$BACKGROUND,bg=blue]#W "

      # set -g window-status-format "#[fg=$BACKGROUND,bg=$COMMENT,nobold,noitalics,nounderscore]#[fg=brightwhite,bg=$COMMENT]#I#[fg=$BACKGROUND,bg=$COMMENT,nobold,noitalics,nounderscore] #[fg=brightwhite,bg=$COMMENT]#W #[fg=$COMMENT,bg=$BACKGROUND,nobold,noitalics,nounderscore] "
      # set -g window-status-current-format "#[fg=$BACKGROUND,bg=blue,nobold,noitalics,nounderscore] #[fg=$BACKGROUND,bg=blue]#I#[fg=$BACKGROUND,bg=blue,nobold,noitalics,nounderscore] #[fg=$BACKGROUND,bg=blue]#W #[fg=blue,bg=$BACKGROUND,nobold,noitalics,nounderscore] "
      set -g window-status-separator ""
    '';
  };
}
