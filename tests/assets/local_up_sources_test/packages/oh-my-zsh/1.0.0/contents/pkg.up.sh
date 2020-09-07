#!/usr/bin/env sh

# * up_init -- Initialize things before executing anything for this package
up_init() {
    up_nop
}

# * up_check -- Checks it this package can be loaded 
up_check() {
    [ -d ~/.oh-my-zsh ] ||\
	up_notify_check_fail
}

# * up_install -- Installs this package if requested
up_install() {
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
}

# * up_config -- Configures everything for this package, aliases, variables,
#                functions ...
up_config() {
    # Setup the zsh theme
    if [ ! -f "$HOME/.oh-my-zsh/themes/suyash.zsh-theme" ]; then
	cp ${SRCDIR}/suyash.zsh-theme ~/.oh-my-zsh/themes/
    fi

    # Path to your oh-my-zsh installation.
    export ZSH="$HOME/.oh-my-zsh"

    # Set a custom theme
    ZSH_THEME="suyash"

    # Hyphen insensitive completion
    HYPHEN_INSENSITIVE="true"

    # Disable auto-update
    DISABLE_AUTO_UPDATE="true"

    # Enable corrections of commands and file names
    ENABLE_CORRECTION="true"

    plugins=(
	git
        colored-man-pages
    )

    source $ZSH/oh-my-zsh.sh
}

up_finally() {
    :;
}

