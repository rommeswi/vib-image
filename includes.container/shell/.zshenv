#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

export ZDOTDIR=~/.config/zsh
export HISTFILE="$ZDOTDIR/.zsh_history"     # History file
export ZSHRC="$ZDOTDIR/.zshrc"              # Zsh configuration file
export ZSH_CACHE_DIR="$ZDOTDIR/cache"       # Cache directory for plugins

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
  eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"
fi
