#!/usr/bin/env sh
a=1
# * up_init -- Initialize things before executing anything for this package
up_init() {
    up_nop
}

# * up_check -- Checks it this package can be loaded 
up_check() {
    [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] ||\
	up_notify_check_fail
}

# * up_install -- Installs this package if requested
up_install() {
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
}

# * up_config -- Configures everything for this package, aliases, variables,
#                functions ...
up_config() {
    source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
}

up_finally() {
    :;
}

