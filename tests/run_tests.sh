#! /usr/bin/env sh

. ./common.sh

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

iter=1
total_tests=$(ls "$dir/"*_test.sh "$dir/"*/*_test.sh | wc -l)
fail_count=0

for test_file in "$dir/"*_test.sh "$dir/"*/*_test.sh; do
    test_name=$(basename "$test_file" | sed 's/_test.sh//')
    
    printf "[%2d/%2d] ${yellow}Testing ${cyan}${test_name}...${reset}\n" "$iter" "$total_tests"

    "$SHELL" "$test_file"

    if [ "$?" = "1" ]; then
        fail_count=$((fail_count+1))
        printf "${red}failed${reset}\n"
    else
        printf "${green}passed${reset}\n"
    fi

    iter=$((iter+1))
done
