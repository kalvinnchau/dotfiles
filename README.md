# dotfiles

## init

1. intall some packages
```bash
# install zinit plugin manager
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew install fzf tree jq
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

4. install rust, cargo and some tools
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install ripgrep
cargo install --locked bat
cargo install fd-find
cargo install du-dust
cargo install starship
cargo install git-delta
```

5. brew packages
```bash
brew tap weaveworks/tap
brew install kubectl
brew install eksctl
brew install helm
brew install kubectx
brew install aws-iam-authenticator
```

## other stuff

### install nerd fonts
This installs the latest SourceCodePro font set
```bash
cd ~/Library/Fonts && \
  curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    jq -r '.assets[] | select(.name == "SourceCodePro.zip") | .browser_download_url' |
    xargs -I{} curl -s -L -O {} && \
  unzip SourceCodePro.zip
```

### jvm

Use `jenv` to mange all the version fun

```bash
brew install jenv

# java intalls the latest
brew install java java11

# if you still need java8
brew tap AdoptOpenJDK/openjdk
brew cask install adoptopenjdk8

mkdir -p "$HOME/.jenv/versions/"

jenv add $(/usr/libexec/java_home)
jenv add /Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home
jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

jenv global <set version>
```

### nvm/node
docs at [nvm-sh/nvm](https://github.com/nvm-sh/nvm)
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

nvm use <>
```

### nvim lsp

```
npm install -g npm
npm i -g prettier
npm i -g bash-language-server
npm i -g diagnostic-languageserver
npm i -g typescript-language-server

brew install shellcheck
brew install shfmt
```

## todo
- [ ] script installation of step 4+
