#!/usr/bin/env sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# (C) Copyright 2020 Suyash Mahar

. ./common.sh

run_up() {
    HOME="$REAL_HOME" __up_get_source \
        'git:"/home/s/git/up_sources_stable"' \
        >/dev/null
}

check_up() {
    if [ ! -d "${HOME}/.use-package.sh/cache/up_sources_stable" ]; then
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
