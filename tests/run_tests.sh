#! /usr/bin/env sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
#
# (C) Copyright 2020-21 Suyash Mahar

. ./common.sh

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

iter=1
total_tests=$(ls "$dir/"*/*_test.sh | wc -l)
fail_count=0

export UP_LOC=

for test_file in "$dir/"*/*_test.sh; do
    test_name=$(echo "$test_file" | sed 's/_test.sh//' | sed "s|$(pwd)/||")
    echo "$test_file" | grep -q '_fail_test.sh'
    should_fail=$?

    progress=$(printf "[%d/%d] " "$iter" "$total_tests")
    spacer=$(printf "%${#progress}s" "")
    
    printf "${progress}${yellow}Testing ${cyan}${test_name}...${reset}"

    "$SHELL" "$test_file"

    if [ "$?" = "1" -a "$should_fail" = "1" ] || [ "$?" = "0" -a "$should_fail" = "0" ]; then
        fail_count=$((fail_count+1))
        printf "${red}failed${reset}\n"
    else
        printf "${green}passed${reset}\n"
    fi

    iter=$((iter+1))
done
