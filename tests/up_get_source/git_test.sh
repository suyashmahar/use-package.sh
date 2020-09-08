#!/usr/bin/env sh

. ./common.sh

function run_up() {
    HOME="$REAL_HOME" up_get_source \
        'git:"/home/s/git/up_sources_stable"' #\
        #>/dev/null
}

function check_up() {
    local expected_hash="74b2f7c4f51b20e6c5805f8de4b89100"
    local result_hash=$(md5sum "${HOME}/.use-package.sh/cache/sources.list" | awk '{ print $1 }')

    if [ "$expected_hash" != "$result_hash" ]; then
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
