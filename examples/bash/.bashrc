# Setup use-package.sh

if [ ! -f "$HOME/.use-package.sh/up.sh" ]; then
    mkdir -p "$HOME/.use-package.sh"
    # wget "https://raw.githubusercontent.com/suyashmahar/use-package.sh/master/src/up.sh?token=AFA6VT7RYFW4WHOC5NVIDB27MHMCS" -O "$HOME/.use-package.sh/up.sh"
    cp "/home/s/git/use-package.sh/src/up.sh" "$HOME/.use-package.sh/up.sh"
fi

. "$HOME/.use-package.sh/up.sh"

# Load the packages
up_load_sources \
    git:"/home/s/git/up_sources_stable"

up_load_pkgs \
    cargo
