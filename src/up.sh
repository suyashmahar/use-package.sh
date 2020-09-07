#!/usr/bin/env sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

############
## Helper ##
############

up_say() {
    local msg="$1"
    printf "${msg}\n"
}

up_verbose() {
    local msg="$1"
    if [ "$VERBOSE" = "1" ]; then
	printf " VERB: ${msg}\n"
    fi
}

up_warn() {
    local msg="$1"
    printf " WARN: ${msg}\n"
}

up_fatal() {
    local msg="$1"
    printf "FATAL: ${msg}\n"
    exit 1
}

#################
## Backend API ##
#################

# * up_notify_check_fail -- Notify up from package script about failed check
up_notify_check_fail() {
    local add_info=$1
    
    up_verbose "Check failed, additional info: ${add_info}"

    up_check_passed=1
}

# * up_notify_done -- Notify up from package script about successful completion
up_notify_done() {
    echo "Done with package $up_cur_pkg"
}

# * up_nop -- Does nothing
up_nop() {
    :;
}

# * up_ensure -- Checks if a command exists
up_ensure() {
    local cmd=$1

    local result=1
    if ! type "$cmd" > /dev/null; then
	up_notify_check_fail
    fi
}

# * up_check_passed -- Holds the status of the checks executed so far, only
#                      valid during package execution, 0 -> all passed,
#                      1 -> at least one failed
up_check_passed=0

#####################
## Universal Stuff ##
#####################

# * UP_LOCAL_CACHE -- Points to the local storage of all the sources
export UP_LOCAL_CACHE="$HOME/.use-package.sh/cache"
# * UP_SOURCES_LIST -- Points to a file that stores the list of sources
export UP_SOURCES_LIST="${UP_LOCAL_CACHE}/sources.list"

# * up_check_args -- Check if the input argument is empty
up_check_empty() {
    if [ "$1" = "" ]; then
	return 1
    else
	return 0
    fi
}

# * up_setup_sources_dir -- Setups the local cache for packages
up_setup_sources_dir() {
    mkdir -p UP_LOCAL_CACHE
}

# * up_check_source_dir -- Checks a source directory to make sure it is a up
#                          source directory
up_check_source_dir() {
    local src_dir=$1

    
}

# * up_get_source() -- Retreives local or network package sources
up_get_source() {
    local source=$1

    source_type="$(echo $source | grep -oE '(^network)|(^local)|(^git)')"
    source_addr="$(echo $source | sed -E 's/(^network:)|(^local:)|(^git:)//')"

    
    local source_addr_clean="${source_addr%\"}"
    source_addr_clean="${source_addr_clean#\"}"
    
    echo "Getting source of type '$source_type' from '$source_addr_clean'"

    local source_name=$(basename "${source_addr_clean}")
    local dest_dir=""
    
    case "${source_type}" in
        'git')
	    dest_dir="${UP_LOCAL_CACHE}/${source_name}"
	    git clone "${source_addr_clean}" "${UP_LOCAL_CACHE}/${source_name}" >/dev/null 2>&1 || {
		up_fatal "Cannot clone '$source_addr_clean', make sure you have access to the repository"
	    }
            ;;
        'network')
            ;;
        'local')
	    if [ ! -d "${source_addr_clean}" ]; then
		up_fatal "Source directory '$source_addr_clean' not found"
	    fi
	    
	    dest_dir="${UP_LOCAL_CACHE}/${source_name}.local"
	    cp -r "${source_addr_clean}" "${dest_dir}"
            ;;
        *)
	    up_fatal "Unkown protocol '$source_type'"
            ;;
    esac
}

# * up_load_sources -- Loads all the sources to up's local directory
up_load_sources() {
    # Make sure everything is setup
    up_setup_sources_dir

    # for arg do

    # done

}
