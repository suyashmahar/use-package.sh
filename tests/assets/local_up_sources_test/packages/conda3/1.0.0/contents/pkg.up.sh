#!/usr/bin/env sh

# * up_init -- Initialize things before executing anything for this package
up_init() {
    up_nop
}

# * up_install -- Installs this package if requested
up_install() {
    bash <(wget -qO- https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh)
}

# * up_check -- Checks it this package can be loaded 
up_check() {
    [ -f "/home/s/anaconda3/bin/conda" ] || up_notify_check_fail
}

# * up_config -- Configures everything for this package, aliases, variables,
#                functions ...
up_config() {
    __conda_setup="$('/home/s/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
	eval "$__conda_setup"
    else
	if [ -f "/home/s/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/home/s/anaconda3/etc/profile.d/conda.sh"
	else
            export PATH="/home/s/anaconda3/bin:$PATH"
	fi
    fi
    unset __conda_setup
}

up_finally() {
    :;
}

