#!/usr/bin/env sh

# Order of function calls by use-package.sh:
#
#   up_init()
#       |
#       |<---------------------------+
#       |                            |
#       V                            |
#   up_check() ---[failed]---> up_install()
#       |
#       |
#       V
#   up_config()
#       |
#       |
#       V
#   up_finally()   

# * up_init -- Initialize things before executing anything for this package
#
# Details:
# This is the first function called by use-package.sh for this package, this
# function should be used to initialize something that cannot be done later.
up_init() {
    up_nop # up_nop does nothing
}


# * up_check -- Checks if this package can be loaded
#
# Details:
# up_check is called by use-package.sh to check if package is installed.
# A typical check would be to see if a binary is present, e.g., htop.
# To notify use-package.sh that this package is not installed, you can use
# two different functions:
# 1. up_ensure <command name>: Checks and notifies use-package if this command
#                              is not defined
# 2. up_notify_check_fail: Tells use-package.sh that this check has failed
up_check() {
	# To check cargo is available, do
    up_ensure "cargo"

	# Or, you can manually check for this command
	if ! type "cargo" > /dev/null; then
		up_notify_check_fail
	fi
}

# * up_install -- Installs this package if requested
#
# Details:
# use-package.sh only calls this function if the check on this function failed
up_install() {
    sudo apt-get install -y cargo
}

# * up_config -- Configures everything for this package, aliases, variables,
#                functions ...
#
# Details:
# This function is called if the check passes or after the package is installed.
# All the configuration for this package should be done here
up_config() {
    export PATH="$HOME/.cargo/bin:$PATH"
}

# * up_finally -- Function called after everything regardless of if they failed
#
# Details:
# This should be used to cleanup anything done during the call by use-package.sh
up_finally() {
    up_nop
}

