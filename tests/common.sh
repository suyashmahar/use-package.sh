
# Setup the environment variable to prevent up from executing directly
if [ "$TMPDIR" = "" ]; then
    export TMPDIR="/tmp"
fi
export UP_TEST_MODE=1
export REAL_HOME="$HOME"
export FAKE_HOME="${TMPDIR}/use_package_fake_home"

# Colors
black='\e[30m'
blue='\e[34m'
cyan='\e[36m'
grey='\e[30;1m'
green='\e[32m'
magenta='\e[35m'
red='\e[31m'
white='\e[37m'
yellow='\e[33m'
reset='\e[0m'

test_failed() {
    exit 1
}

init_fake_home() {
    # Make sure the FAKE home is not under /home
    if echo "$FAKE_HOME" | grep -q '/home'; then
	echo "FAKE_HOME points to possible REAL_HOME"
	exit 1
    fi
    
    # Remove the directory if it exists
    if [ -d  "$FAKE_HOME" ]; then
        rm -rf "$FAKE_HOME"
    fi

    # Create and set the fake home
    mkdir -p "$FAKE_HOME"
    export HOME="$FAKE_HOME"
}

finish_fake_home() {
    export HOME="$REAL_HOME"
}
