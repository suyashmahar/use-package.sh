#!/usr/bin/env sh

# * up_init -- Initialize things before executing anything for this package
up_init() {
    up_nop
}

# * up_check -- Checks it this package can be loaded 
up_check() {
    [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] ||\
	up_notify_check_fail
}

# * up_install -- Installs this package if requested
up_install() {
    mkdir -p "$HOME/.zsh"
    git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.zsh/zsh-autosuggestions"
}

# * up_config -- Configures everything for this package, aliases, variables,
#                functions ...
up_config() {
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
}

up_finally() {
    :;
}

