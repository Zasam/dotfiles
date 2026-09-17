# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

# ALIASES
# - General
alias dev='cd ~/dev'
alias data='/home/nicklas/Data'
alias files='xdg-open .'
alias dot='/usr/bin/git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
    __git_complete dot _git
fi

# - Neovim
alias vim='nvim'

# - Dotnet
alias dr='dotnet run'
alias dw='dotnet watch run'
alias db='dotnet build'
alias bp-linux64='dotnet publish -r '

# Rust
alias cr='cargo run'

# EXPORTS
if [ -d "$HOME/.local/share/mise/installs/dotnet/latest" ]; then
  export DOTNET_ROOT=$HOME/.local/share/mise/installs/dotnet/latest
  export PATH=$DOTNET_ROOT:$PATH
fi
[ -d "$HOME/.dotnet/tools" ] && export PATH="$PATH:$HOME/.dotnet/tools"
[ -d /home/nicklas/data/ocr ] && export TESSDATA_PREFIX=/home/nicklas/data/ocr
export LIBGL_ALWAYS_SOFTWARE=1
export WEBKIT_DISABLE_DMABUF_RENDERER=1
if [ -d "$HOME/Android/Sdk" ]; then
  export ANDROID_HOME=$HOME/Android/Sdk
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/build-tools/36.0.0
fi
export PATH="$HOME/.cargo/bin:$PATH"
export HA_URL=http://192.168.178.40:8123

# fzf fuzzy Ctrl-R (history) / Ctrl-T (files) / Alt-C (cd)
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

# Secrets (NUGET_API_KEY, HA_TOKEN, ...) live outside version control
[ -f "$HOME/.bash_secrets" ] && source "$HOME/.bash_secrets"

# Machine-local overrides that shouldn't apply to every machine in the dotfiles repo
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

fcd() {
  local dir
  dir=$(fd --type d . / /var /srv /home /mnt 2>/dev/null | fzf) && cd "$dir" || return
}

track_project_dir() {
  mkdir -p ~/.cache
  printf "%s\n" "$PWD" >~/.cache/current_project_dir
}

trap 'track_project_dir' DEBUG

# Atlas
agent-deploy() {
  /home/nicklas/dev/ATLAS/agent/deploy.sh
}

atlas-deploy() {
  (cd /home/nicklas/dev/ATLAS && bash deploy.sh)
}

# Load Angular CLI autocompletion.
command -v ng &>/dev/null && source <(ng completion script)

[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"
