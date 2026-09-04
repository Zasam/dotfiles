#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc


# Added by Toolbox App
export PATH="$PATH:/home/nicklas/.local/share/JetBrains/Toolbox/scripts"

# ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_ed25519
# Only prompt for the passphrase when there's a real terminal attached —
# headless/non-interactive shells (e.g. tool-driven subshells) have no tty
# and no working SSH_ASKPASS, so keychain/ssh-add would just fail noisily.
[ -t 0 ] && eval $(keychain --quiet --eval id_ed25519)

. "$HOME/.local/share/../bin/env"
