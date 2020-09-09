#!/usr/bin/env sh

# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

############
## Helper ##
############

# Check if the terminal supports colors, if it is doesn't then disable
# colors
if [ -t 1 ]; then
    color_cnt=$(tput colors)
    if [ -n "$color_cnt" ] && [ $color_cnt -ge 8 ]; then
	UP_RESET=$(echo -en '\033[0m')
	UP_RED=$(echo -en '\033[00;31m')
	UP_GREEN=$(echo -en '\033[00;32m')
	UP_YELLOW=$(echo -en '\033[00;33m')
	UP_BLUE=$(echo -en '\033[00;34m')
	UP_MAGENTA=$(echo -en '\033[00;35m')
	UP_PURPLE=$(echo -en '\033[00;35m')
	UP_CYAN=$(echo -en '\033[00;36m')
	UP_LIGHTGRAY=$(echo -en '\033[00;37m')
	UP_LRED=$(echo -en '\033[01;31m')
	UP_LGREEN=$(echo -en '\033[01;32m')
	UP_LYELLOW=$(echo -en '\033[01;33m')
	UP_LBLUE=$(echo -en '\033[01;34m')
	UP_LMAGENTA=$(echo -en '\033[01;35m')
	UP_LPURPLE=$(echo -en '\033[01;35m')
	UP_LCYAN=$(echo -en '\033[01;36m')
	UP_WHITE=$(echo -en '\033[01;37m')
    fi
fi

up_say() {
    local msg="$1"
    printf "${msg}\n"
}

up_verbose() {
    local msg="$1"
    if [ "$VERBOSE" = "1" ]; then
	printf " VERB: ${msg}\n" >&2
    fi
}

up_warn() {
    local msg="$1"
    printf " WARN: ${msg}\n" >&2
}

up_fatal() {
    local msg="$1"
    printf "${UP_RED}FATAL: ${msg}${RESET}\n" >&2
    exit 1
}

return_val() {
    local value="$1"

    echo "$value"
}

####################
## Internal stuff ##
####################

__up_setup_env() {
    unset -f __UP_INIT_FUNC 2>/dev/null
    unset -f __UP_INSTALL_FUNC 2>/dev/null
    unset -f __UP_CHECK_FUNC 2>/dev/null
    unset -f __UP_CONFIG_FUNC 2>/dev/null
    unset -f __UP_FINALLY_FUNC 2>/dev/null

    # Reset the check accumulator
    __up_check_result_reset
}

__up_check_result_reset() {
    up_check_passed=0
}

__up_check_result() {
    return "$up_check_passed"
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
    mkdir -p "$UP_LOCAL_CACHE"

    if [ ! -f "$UP_SOURCES_LIST" ]; then
	touch "$UP_SOURCES_LIST"
    fi
}

# * up_get_id_from_source -- Convert a use-package source to source id
#
# Example:
#     'git:"https://github.com/suyashmahar/up_sources_stable.git"' -> 'git:up_sources_stable'
up_get_id_from_source() {
    local source=$1

    local source_type="$(echo $source | grep -oE '(^network)|(^local)|(^git)')"
    local source_addr="$(echo $source | sed -E 's/(^network:)|(^local:)|(^git:)//')"

    local source_addr_clean="${source_addr%\"}"
    source_addr_clean="${source_addr_clean#\"}"

    local source_name=$(basename "${source_addr_clean}")
    local source_id=""
    
    case "${source_type}" in
        'git')
	    source_id="$(echo $source_name | sed 's/.git//')"
            ;;
        'network')
            ;;
        'local')
	    source_id="${source_name}"
            ;;
        *)
	    up_fatal "Unknown protocol '$source_type'"
            ;;
    esac

    echo "${source_type}:${source_id}"

}

# * up_check_cache_for_source -- Checks if a source exists locally
#
# Outputs:
#     'exists': Indicates that the source already exists
#     'missing': Indicates that the source doesn't exists locally
up_check_cache_for_source() {
    local source=$1

    local source_id=$(up_get_id_from_source "$source")
    local exists=$(cat "$UP_SOURCES_LIST" | grep -o "$source_id")

    local result=""
    if [ "$exists" != "" ]; then
	result="exists"
    else
	result="missing"
    fi

    echo "$result"
}

# * up_check_source_dir -- Checks a source directory to make sure it is a up
#                          source directory
up_check_source_dir() {
    local src_dir=$1

    if [ ! -f "${src_dir}/packages.list" ]; then
	up_fatal "'${src_dir}/packages.list' not found"
    fi

    if [ ! -d "${src_dir}/packages" ]; then
	up_fatal "Directory '${src_dir}' does not have a 'packages' sub directory"
    fi

    # Read every line of packages.list file and check if corresponding
    # package file is valid
    local line_num=0
    while read -r line; do
	# Increase line number here, branching later is just weird
	line_num=$((line_num+1))
	case "$line" in
	    # Ignore comments
	    \#*)
		continue
	    ;;
	    # Anything that is not a comment
	    *)
		# Check if this line is empty
		if [ "$line" = "" ]; then
		    continue
		fi
		
		local pkg_details=$(printf "%s" "$line" | xargs -n 1 printf "%s\n")

		# pkg_details should have two lines, corresponding to
		# the two tokens
		local token_cnt=$(echo "$pkg_details" | wc -l)
		if [ "${token_cnt}" != "2" ]; then
		    local msg="${src_dir}/packages.list:${line_num} Wrong syntax."
		    msg="${msg} Got ${token_cnt} token(s), expected 2."
		    up_fatal "$msg"
		fi
		
		# Get the first and second arguments
		local pkg_name=$(echo "$pkg_details" | head -n1)
		local pkg_desc=$(echo "$pkg_details" | head -n2 | tail -n1)

		# Check if there is a corresponding package for this
		# name
		if [ ! -d "${src_dir}/packages/${pkg_name}" ]; then
		    up_fatal "Package '${pkg_name}' is listed but does not have a package directory"
		fi

		# TODO: add other checks, e.g., pkg.up.sh file
	    ;;
	esac
    done < "${src_dir}/packages.list"
    
}

# * up_get_source() -- Retreives local or network package sources
up_get_source() {
    local source="$1"
    
    source_type="$(echo $source | grep -oE '(^network)|(^local)|(^git)')"
    source_addr="$(echo $source | sed -E 's/(^network:)|(^local:)|(^git:)//')"
    
    local source_addr_clean="${source_addr%\"}"
    source_addr_clean="${source_addr_clean#\"}"
    
    up_verbose "Getting source of type '$source_type' from '$source_addr_clean'"

    # Check if this source already exists
    local local_avail=$(up_check_cache_for_source "$source")
    if [ "$local_avail" = "exists" ]; then
	up_fatal "Source '$source' already exists"
    fi

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
	    up_fatal "Unknown protocol '$source_type'"
            ;;
    esac

    local retrival_time=$(date +%s)
    local source_id=$(up_get_id_from_source "$source")
    echo "${retrival_time} ${source_id}" >> "${UP_SOURCES_LIST}"

    # Check for any configuration error in the source's directory
    up_check_source_dir "${dest_dir}"    
}

# * up_load_pkg -- Load a single package at the given path
up_load_pkg_loc() {
    local pkg_loc="$1"

    up_pkg_name=$(basename "$file" | sed 's/.up.sh//g')

    up_verbose "Working on package '${up_pkg_name}'"

    __up_setup_env

    . "$pkg_loc"

    up_verbose "Calling init..."
    up_init

    up_verbose "Calling check..."
    up_check

    if ! __up_check_result; then
	up_verbose "Check failed, trying install..."
	up_install

	# Reset the check accumulator
	__up_check_result_reset
	
	up_verbose "Calling check again..."
	up_check

	if ! __up_check_result; then
	    up_verbose "Install failed to setup environment, not trying anymore..."
	    return 1
	fi
    fi

    up_verbose "Calling config..."
    up_config

    up_verbose "Calling finally..."
    up_finally

    up_verbose "Done with $up_pkg_name"
}

# * up_find_package_in_source -- Finds a package in a cached source directory
# Output:
#     'missing': If this package was not found in any of the sources
#     <path to package>: Path to the first latest version of the first package
#                        found
# TODO:
#     Check @ref up_find_package
up_find_package_in_source() {
    local package_name="$1"
    local source_id="$2"

    up_verbose "Finding package '${package_name}' in source '${source_id}'"

    local source_type="$(echo $source_id | cut -d ':' -f 1)"
    local source_name="$(echo $source_id | cut -d ':' -f 2-)"

    # Remove any quotes
    source_name="${source_name%\"}"
    source_name="${source_name#\"}"
    
    local source_dir="${UP_LOCAL_CACHE}/${source_name}.${source_type}"
    local packages_list="${source_dir}/packages.list"
    
    if [ ! -f "${packages_list}" ]; then
	up_fatal "Cannot find package list: '${packages_list}', is source corrupted?"
    fi

    local result="missing"
    
    while read -r line; do
	if [ ! -z "$line" ]; then

	    # Check if this entry matches the package we are searching
	    local cur_name=$(echo "$line" | cut -d ' ' -f1)
	    if [ "$cur_name" = "$package_name" ]; then
		
		# If we have a match, get the path of the package's
		# up.sh file. Use the latest version for this
		#
		# Warn: up only supports upto four part version number
		# (e.g., 1.0, 1.0.0, 1.0.0.0)
		local package_dir="${source_dir}/packages/${package_name}"
		local package_versions=$(ls -d "${package_dir}"/*/ \
					     | sort -t '.' \
						    -k 1,1 -k 2,2 -k 3,3 -k 4,4\
						    -n)
		local latest_version=$(echo "$package_versions" | tail -n1)
		latest_version=$(basename "$latest_version")

		up_verbose "Found version '${latest_version}'"
		
		local loader_file="${package_dir}/${latest_version}/contents/pkg.up.sh"
		if [ ! -f "${loader_file}" ]; then
		    up_fatal "Cannot find '${loader_file}', source corrupted?"
		fi

		result="${loader_file}"
		
		break
	    fi
	fi
    done < "${packages_list}"

    return_val "${result}"
}

# * up_find_package -- Finds a package in existing sources
# Output:
#     'missing': If this package was not found in any of the sources
#     <path to package>: Path to the first latest version of the first package
#                        found
# TODO:
#     1. Add source selection for packages with same name in different sources
#     2. Add version selection for package with multiple versions
up_find_package() {
    local package_name="$1"
    
    local result="missing"
    while read -r line; do
	# Right now everything after the first field in every line
	# is expected to be a package id, in future when more
	# fields will get added, things will be more complicated
	# to parse.
	local source_id=$(echo "$line" | cut -d " " -f 2-)
	
	up_verbose "Looking in source ${source_id}"
	result="$(up_find_package_in_source "${package_name}" "${source_id}")"
    done < "${UP_SOURCES_LIST}"

    return_val "${result}"
}

  ##################
  ## Frontend API ##
  ##################

# * up_load_sources -- Loads all the sources to up's local directory
up_load_sources() {
    # Make sure everything is setup
    up_setup_sources_dir

    for arg do
	local exists=$(up_check_cache_for_source "$arg")
	up_verbose "Checking $arg ... exists=${exists}"

	if [ "${exists}" = "missing" ]; then
	    up_verbose "Source missing, retrieving..."
	    up_get_source "$arg"
	else
	    up_verbose "Source exists, skipping"
	fi
    done
}

# * up_load_pkg -- Loads specified packages from source
up_load_pkg() {

    for arg; do
	up_verbose "Loading package '${arg}'..."

	local pkg_loc="$(up_find_package ${arg})"

	if [ "$pkg_loc" = "missing" ]; then
	    up_fatal "Package '${arg}' not found"
	fi

	# We found the package, let's load it
	up_verbose "Found the package at ${pkg_loc}"
	up_load_pkg_loc "${pkg_loc}"
    done

}
