
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

zinit wait lucid light-mode for \
    kazhala/dotbare

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U compinit && compinit

##
# zsh settings
##
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.  setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
# Share history between sessions
HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_SPACE

setopt MONITOR
setopt NO_HUP
unsetopt HUP

# Delete backwards one word when its delimited by '/' or '.'
tcsh-backward-delete-word () {
      local WORDCHARS="${WORDCHARS:s#/#}"
      local WORDCHARS="${WORDCHARS:s#.#}"
      zle backward-delete-word
}

bindkey '^W' tcsh-backward-delete-word
bindkey '^[^?' tcsh-backward-delete-word
zle -N tcsh-backward-delete-word

##
# aliases
##
alias vi=nvim
alias vim=nvim
# List all files colorized in long format
alias ll='ls -lha'
alias rr="rsync -rvzP"
alias ssh="ssh -oStrictHostKeyChecking=no -oCheckHostIP=no -oConnectionAttempts=5 -oConnectTimeout=8 -oServerAliveInterval=5 -oTCPKeepAlive=no -Y"
alias cfg=dotbare


##
# export environment variables
##
export HISTCONTROL=ignoredups,ignorespace
export HISTFILESIZE=50000
export HISTSIZE=${HISTFILESIZE}

# Use only virtualenvs
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

export EDITOR=nvim

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export FZF_DEFAULT_OPTS='--height 100%'
export DOTBARE_DIR="$HOME/.config"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
export PATH=$PATH:/usr/local/bin
