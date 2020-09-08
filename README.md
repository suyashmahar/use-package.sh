<p align="center">
  <img height="200" src="assets.github/banner.svg">
</p>

[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

# use-package.sh
A package manager (sort of) for your shell script to keep your shellrc file clutter free.

## Sales Pitch 
* Are you tired of maintaining your 100-1000s lines of rc file?s
* Do you wish to have your environment setup instantly whenever you start fresh on a machine?
* Do you believe managing RC files should be simple?

use-package.sh solves all these problems for you!

## But, how does it work?
Setting up use-package.sh is a 2-ish step job:

1. You add an include statement to the top of your shell's rc file:

```shell
# If not available, download use-package.sh
if [ ! -f "$HOME/.use-package.sh/use-package.sh" ]; then
    mkdir -p "$HOME/.use-package.sh"
    wget "https://github.com/suyashmahar/releases/use-package-1.0.0.sh"
fi
. "$HOME/.use-package.sh/use-package.sh
```

2. You then specify the sources and packages that you want to enable:
```shell
# Specify the package sources, local or network
up_load_sources \
    network:"https://github.com/suyashmahar/up_sources"

# Load selected packages
up_load_package \
    cargo \
    conda
```

And, voila your .${SHELL}rc is ready!

Your shell's rc file should look like:
```
# If not available, download use-package.sh
if [ ! -f "$HOME/.use-package.sh/use-package.sh" ]; then
    mkdir -p "$HOME/.use-package.sh"
    wget "https://github.com/suyashmahar/releases/use-package-1.0.0.sh"
fi

. "$HOME/.use-package.sh/

# Specify the package sources, local or network
up_load_sources \
    "https://github.com/suyashmahar/use-package.sh/default.up_sources"

# Load selected packages
up_load_package \
    oh-my-zsh \
    zsh-syntax-highlighting \
    zsh-auto-completion \
    cargo \
    conda
```

**Note on internet requirement**  
In case you are using network repositories (e.g., use-package.sh's default repository) you would need to connect to the internet just for the first time. use-package.sh downloads packages locally and would not connect to the internet unless explicitly asked to.


*To have your own repository, check `docs/` for more details*

### List of packages available with use-package.sh's default repository
#### Common
* [conda3]()
* [conda2]()
* [cargo]()
* [cargo-goodies]()
#### Zsh specific
* [oh-my-zsh]()
* [zsh-auto-suggestions]()
* [zsh-syntax-highlighting]()
#### Bash specific
* [oh-my-bash]()

## Creating new packages


## I still have some questions
1. **I don't want to execute code from the internet**  
Sure thing, you can run use-package-setup.sh to do everything offline. This however will require few extra steps.
2. **Does it support my shell?**  
use-package.sh is written ground up to be POSIX compliant. If your shell support POSIX commands, use-package.sh will work.
3. **Why does use-package.sh have weird syntax**
POSIX compliance meant that some sacrifices had to be made, this included avoiding the use of arrays.
