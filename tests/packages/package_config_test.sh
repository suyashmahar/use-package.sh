#!/usr/bin/env sh

. ./common.sh

function run_up() {
    # Load the default test source
    up_load_sources \
        local:"$(pwd)/assets/local_up_sources_test"
    up_load_pkg \
	test_pkg
}

function check_up() {
    local pkg_loc="$(up_find_package "conda2")"

    local expected="success"
    if [ "$(test_pkg_function)" != "$expected" ]; then
	echo "Expected '$expected', got '$pkg_loc'"	
	test_failed "$0"
    fi
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
