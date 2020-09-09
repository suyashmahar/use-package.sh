#!/usr/bin/env sh

. ./common.sh

run_up() {
    up_load_sources \
        local:"$(pwd)/assets/local_up_sources_test" \
	local:"$(pwd)/assets/local_up_sources_test" \
        local:"$(pwd)/assets/local_up_sources_test" \
        >/dev/null
}

check_up() {
    if [ ! -d "${HOME}/.use-package.sh/cache/local_up_sources_test.local" ]; then
        test_failed "$0"
    fi
}

# Perform all operations inside a fake home
init_fake_home
    
    . ../src/up.sh

    # Setup the sources cache
    __up_setup_sources_dir

    # Run the target function
    run_up

    # Check if it worked
    check_up

finish_fake_home
