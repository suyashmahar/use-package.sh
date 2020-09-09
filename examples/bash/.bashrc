# Setup use-package.sh

if [ ! -f "$HOME/.use-package.sh/up.sh" ]; then
    mkdir -p "$HOME/.use-package.sh"
    wget "https://raw.githubusercontent.com/suyashmahar/use-package.sh/master/src/up.sh?token=AFA6VT7RYFW4WHOC5NVIDB27MHMCS" -O "$HOME/.use-package.sh/up.sh"
fi

. "$HOME/.use-package.sh/up.sh"

# Load the packages
up_load_sources \
    network:"https://codeload.github.com/suyashmahar/up_sources_stable/tar.gz/0.1b?token=AFA6VT5LILIB5WY7OBWBJUK7LCS5E"

up_load_pkgs \
    cargo
