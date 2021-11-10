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
    zinit-zsh/z-a-bin-gem-node \
    zsh-users/zsh-completions

### End of Zinit's installer chunk

zinit wait lucid light-mode for \
    kazhala/dotbare \
    zdharma/fast-syntax-highlighting\
    zsh-users/zsh-autosuggestions

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

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
setopt APPEND_HISTORY # Don't erase history
setopt EXTENDED_HISTORY # Add additional data to history like timestamp
setopt INC_APPEND_HISTORY # Add immediately
setopt HIST_FIND_NO_DUPS # Don't show duplicates in search
setopt HIST_IGNORE_SPACE # Don't preserve spaces. You may want to turn it off
setopt NO_HIST_BEEP # Don't beep
setopt SHARE_HISTORY # Share history between session/terminals

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
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export PATH=$PATH:"$HOME/.local/bin"
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

# speed up init time, rehash in the background
if command -v jenv &> /dev/null; then
  eval "$(jenv init - --no-rehash)"
  (jenv rehash &) 2> /dev/null
fi

command -v starship &> /dev/null && eval "$(starship init zsh)"

# lazy load nvm until nvm, node or a node-dependent command is run
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  NODE_GLOBALS=($(find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq))
  NODE_GLOBALS+=("node")
  NODE_GLOBALS+=("nvm")
  # Lazy-loading nvm + npm on node globals
  load_nvm () {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  }
  # Making node global trigger the lazy loading
  for cmd in "${NODE_GLOBALS[@]}"; do
    eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
  done
fi


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/s5cmd s5cmd

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
[ -s "/opt/homebrew/bin/brew" ] && eval "$(/opt/homebrew/bin/brew shellenv)"

##
# functions
##
if [ -d ~/.config/zsh ]; then
  for f in ~/.config/zsh/*.sh; do
    [ -r "$f" ] && source "$f"
  done
fi
