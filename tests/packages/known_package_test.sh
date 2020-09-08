#!/usr/bin/env sh

. ./common.sh

function run_up() {
    # Load the default test source
    up_load_sources \
        local:"$(pwd)/assets/local_up_sources_test" \
        >/dev/null
}

function check_up() {
    up_find_package "conda2"
}

# Perform all operations inside a fake home
init_fake_home
    
    . ../src/up.sh

    # Setup the sources cache
    up_setup_sources_dir

    # Run the target function
    run_up

    # Check if it worked
    check_up

finish_fake_home
