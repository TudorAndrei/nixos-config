if [[ "$ZSH_PROF" == "1" ]]; then
  zmodload zsh/zprof
fi

# Basic options
setopt autocd
setopt histignorespace
setopt sharehistory
setopt histexpiredupsfirst
setopt histignoredups

# Vim mode
bindkey -v
export KEYTIMEOUT=1

export BUN_INSTALL="$HOME/.bun"

# Completion - cache for 24 hours
fpath=(${XDG_DATA_HOME:-$HOME/.local/share}/mise-completions/zsh $fpath)
autoload -Uz compinit
dump_file="${ZDOTDIR:-$HOME}/.zcompdump"
# stat: -f %m on macOS/BSD, -c %Y on GNU/Linux
dump_mtime=$(stat -f %m "$dump_file" 2>/dev/null || stat -c %Y "$dump_file" 2>/dev/null || echo 0)
if [[ -f "$dump_file" && $(($(date +%s) - dump_mtime)) -lt 86400 ]]; then
    compinit -C
else
    compinit
fi

codex-clean() {
    local real_home="$HOME"
    local repo_root

    if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
        echo 'codex-clean: run this command inside a Git repository' >&2
        return 1
    fi

    HOME="$repo_root" \
        CODEX_HOME="$real_home/.codex-clean" \
        GIT_CONFIG_GLOBAL="$real_home/.gitconfig" \
        command codex --profile clean "$@"
}

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.maestro/bin"

[[ ! -r "$HOME/.opam/opam-init/init.zsh" ]] || source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
autoload -Uz add-zsh-hook
add-zsh-hook -d precmd _opam_env_hook 2>/dev/null

eval "$(mise activate zsh)"

# Zoxide hook (deferred)
if command -v zoxide &>/dev/null; then
    zsh-defer eval "$(zoxide init zsh)"
fi

# FZF key bindings (deferred)
if command -v fzf &>/dev/null; then
    zsh-defer eval "$(fzf --zsh)"
fi

# PDF compress function
pdfcompress() {
    gs -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=144 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=144 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=144 -sOutputFile=${1%.*}.compressed.pdf $1
}

# Environment variables
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL="${TERMINAL:-ghostty}"

# Keep terminal shells from inheriting a stale working directory.
if [[ "${TERM_PROGRAM:-}" =~ ^(ghostty|alacritty)$ && -z "${TMUX:-}" && -z "${HERDR_PANE_ID:-}" && "$PWD" != "$HOME" ]]; then
    cd "$HOME"
fi

# Create local tmux session for dev or main same as worktree setup
flowmux() {
  local session="$(git rev-parse --abbrev-ref HEAD | tr '/' '-')"

  if tmux has-session -t "$session" 2>/dev/null; then
    tmux attach -t "$session"
  else
    tmux new-session -d -s "$session" -n dev-servers
    tmux new-window -t "$session:" -n agent
    tmux select-window -t "$session:agent"
    tmux attach -t "$session"
  fi
}

# Create worktree from dev and attach to tmux session
WT_TMUX_EXEC='S=wt-{{ branch | sanitize }}; while ! tmux has-session -t "$S" 2>/dev/null; do sleep 0.2; done; if [ -n "$TMUX" ]; then tmux switch-client -t "$S" 2>/dev/null || tmux attach -t "$S"; else tmux attach -t "$S"; fi'

wtsw() {
  wt switch --create "$1" --base dev --no-cd -x "$WT_TMUX_EXEC"
}

# Attach to current worktree's tmux session (dev-servers window)
wtdev() {
  local session="wt-$(git rev-parse --abbrev-ref HEAD | tr '/' '-')"
  tmux select-window -t "$session:dev-servers" 2>/dev/null
  tmux attach -t "$session"
}

wtrm() {
  wt remove "$1" --force -D
}

# Reuse an existing agent (macOS provides one via launchd) instead of spawning one per shell
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Give mise (and other tools) a GitHub token for higher API rate limits
if command -v gh >/dev/null 2>&1; then
  export GITHUB_TOKEN="${GITHUB_TOKEN:-$(gh auth token 2>/dev/null)}"
fi

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

if [ -n "$HERDR_PANE_ID" ]; then
  for _f in ${HOME}/.config/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.zsh(N); do
    source $_f
    break
  done
fi

if [[ "$ZSH_PROF" == "1" ]]; then
    zprof
fi
