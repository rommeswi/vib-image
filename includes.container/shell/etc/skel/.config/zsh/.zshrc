#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.json)"

alias emacs='emacsclient -c -a ""'
alias e='emacsclient -c -a ""'
alias ls='eza --color=always'
alias ll='eza -l --color=always'
alias la='eza -la --color=always'
alias cat='batcat'
eval "$(zoxide init zsh)"
source /usr/share/doc/fzf/examples/key-bindings.zsh
