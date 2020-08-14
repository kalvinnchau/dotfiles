# dotfiles

## init

1. intall some packages
```bash
# install zinit plugin manager
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install fzf tree
$(brew --prefix)/opt/fzf/install
brew install neovim --HEAD
```

2. install `dotbare`
```bash
zinit light kazhala/dotbare
```

3. initalize the dotfiles
```bash
export DOTBARE_DIR="$HOME/.config"
dotbare finit -u https://github.com/kalvinnchau/dotfiles.git
```

