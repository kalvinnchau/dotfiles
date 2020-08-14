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
alias ssh="ssh -oStrictHostKeyChecking=no -oCheckHostIP=no -oConnectionAttempts=5 -oConnectTimeout=8 -oServerAliveInterval=5 -oTCPKeepAlive=no -Y"
alias cfg=dotbare
# kubernetes aliases
alias k=kubectl
alias kctx=kubectx
alias kns=kubens

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
  colorflag="--color"
else # OS X `ls`
  colorflag="-G"
fi
# List all files colorized in long format
alias ll='ls -lha'

# Always use color output for `ls`
alias ls="command ls ${colorflag}"
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'


##
# export environment variables
##
export EDITOR=nvim

export HISTCONTROL=ignoredups,ignorespace
export HISTFILESIZE=50000
export HISTSIZE=${HISTFILESIZE}

# Use only virtualenvs
export PIP_REQUIRE_VIRTUALENV=true
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

export NVIM_TUI_ENABLE_TRUE_COLOR=1
export FZF_DEFAULT_OPTS='--height 100%'

# dotbare settings
export DOTBARE_DIR="$HOME/.config"
export DOTBARE_FZF_DEFAULT_OPTS="--preview-window=right:70%"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# path configuration
export PATH=$PATH:/usr/local/bin:$HOME/.cargo/bin
export PATH="$HOME/.jenv/bin:$PATH"

command -v jenv &> /dev/null && eval "$(jenv init -)"
command -v starship &> /dev/null && eval "$(starship init zsh)"
