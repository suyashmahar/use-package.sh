#!/usr/bin/env sh

. ./common.sh

run_up() {
    # Load the default test source
    up_load_sources \
        local:"$(pwd)/assets/local_up_sources_test"
}

check_up() {
    local pkg_loc="$(__up_find_package "conda2")"

    local expected="${TMPDIR}/use_package_fake_home/.use-package.sh/cache/local_up_sources_test.local/packages/conda2/1.0.0/contents/pkg.up.sh"
    if [ "$pkg_loc" != "$expected" ]; then
	echo "Expected '$expected', got '$pkg_loc'"	
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
