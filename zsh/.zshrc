# ============================================================
# Basic shell safety
# ============================================================
setopt auto_cd
setopt no_beep

# ============================================================
# PATH
# ============================================================
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:$PATH"

# ============================================================
# Locale
# ============================================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============================================================
# SSH Agent (simple, reliable)
# ============================================================
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null
  ssh-add ~/.ssh/id_ed25519 2>/dev/null
fi

# ============================================================
# Oh My Posh prompt
# ============================================================
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/prompt.toml)"

# ============================================================
# Zinit (plugin manager)
# ============================================================
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# ============================================================
# Oh My Zsh (core only, no theme)
# ============================================================
zinit light ohmyzsh/ohmyzsh

# ============================================================
# Plugins (focused for Python dev)
# ============================================================
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::python
zinit snippet OMZP::pip
zinit snippet OMZP::uv
zinit snippet OMZP::command-not-found

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting

# ============================================================
# Completions
# ============================================================
autoload -Uz compinit && compinit


# ============================================================
# History search (better Ctrl+P / Ctrl+N)
# ============================================================
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# ============================================================
# Aliases
# ============================================================
alias sudo='sudo '
alias ll='ls -lah'
alias gs='git status'

# ============================================================
# Python tooling (optional, safe)
# ============================================================
# Uncomment only what you use

# pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# ============================================================
# fzf (if installed)
# ============================================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ============================================================
# Auto-start tmux
# ============================================================
# Start tmux automatically if:
# - tmux is installed
# - Not already in tmux
# - Not in VSCode terminal
# - Not in SSH (optional: remove this check if you want tmux in SSH)
if command -v tmux &> /dev/null && [ -z "$TMUX" ] && [ -z "$VSCODE_INJECTION" ]; then
  # Attach to existing session named "main" or create it
  tmux attach-session -t main || tmux new-session -s main
fi
