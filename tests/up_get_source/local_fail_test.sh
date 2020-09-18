#!/usr/bin/env sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# (C) Copyright 2020 Suyash Mahar

. ./common.sh

run_up() {
    __up_get_source \
        'local:'$(pwd)'/assets/local_up_sources_test' \
        >/dev/null
    __up_get_source \
        'local:'$(pwd)'/assets/local_up_sources_test' \
        >/dev/null 2>&1
}

check_up() {
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
    __up_setup_sources_dir

    # Run the target function
    run_up

    # Check if it worked
    check_up

finish_fake_home
