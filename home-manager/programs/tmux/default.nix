{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    terminal = "tmux-256color";
    historyLimit = 100000;
    plugins = with pkgs;
      [
        tmuxPlugins.tmux-sensible

        tmuxPlugins.tmux-resurrect
        tmuxPlugins.tmux-prefix-highlight
        tmuxPlugins.tmux-yank
        tmuxPlugins.tmux-open
        tmuxPlugins.tmux-mode-indicator
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.tmux-continuum
# pschmitt/tmux-ssh-split
      ];
    extraConfig = ''
BACKGROUND="#282a36"
SELECTION="#44475a"
COMMENT="#6272a4"

set -g base-index 1           # start windows numbering at 1
setw -g pane-base-index 1     # make pane numbering consistent with windows

setw -g automatic-rename on   # rename window to reflect current program
set -g renumber-windows on    # renumber windows when a window is closed

unbind C-b
set -g prefix C-Space
unbind r
set -g mouse on

# set -g default-terminal /usr/bin/alacritty


set -g default-terminal "screen-256color"
set -g terminal-overrides ',xterm-256color:Tc'
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


tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'

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
set-window-option -g mode-keys vi

# Neovim fix cursor
set -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

# List of plugins

# set-option -g @ssh-split-keep-cwd "true"
# set-option -g @ssh-split-fail "false"
# set-option -g @ssh-split-no-shell "false"
# # set-option -g @ssh-split-strip-cmd "true"
# set-option -g @ssh-split-verbose "false"
# set-option -g @ssh-split-h-key "h"
# set-option -g @ssh-split-v-key "v"


# Plugin settings
set -g @continuum-restore 'on'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'
set -g @resurrect-processes 'ssh'


# DRACULA
set -g focus-events on
set -g status-justify absolute-centre

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
