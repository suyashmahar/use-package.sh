#!/usr/bin/env sh

# * up_init -- Initialize things before executing anything for this package
up_init() {
    up_nop
}

# * up_install -- Installs this package if requested
up_install() {
    sudo apt-get install -y cargo
}

# * up_check -- Checks it this package can be loaded 
up_check() {
    up_ensure "cargo"
}

# * up_config -- Configures everything for this package, aliases, variables,
#                functions ...
up_config() {
    export PATH="$HOME/.cargo/bin:$PATH"
}

up_finally() {
    :;
}

