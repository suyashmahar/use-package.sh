<p align="center">
  <img height="200" src="assets.github/banner.svg">
</p>

[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

# use-package.sh
A package manager for your shellrc to keep it clutter free.

## Sales Pitch
* Do you want your favourite tools to be installed on a new machine when you start?
* Are you tired of maintaining your 100-1000s lines of rc file?
* Do you believe managing RC files should be simple?

use-package.sh solves all these problems for you and does it in painless way!

## But, how does it work?
Setting up use-package.sh is a 3 step job:

1. You add an include statement to the top of your shell's rc file:

```shell
# If not available, download use-package.sh
if [ ! -f "$HOME/.use-package.sh/up.sh" ]; then
    mkdir -p "$HOME/.use-package.sh"
    wget "https://github.com/suyashmahar/releases/use-package-1.0.0.sh"
fi
. "$HOME/.use-package.sh/up.sh
```

2. You'd then need to specify your sources and the packages that you want to enable:

```shell
# Enable use-package.sh's default source
up_load_sources \
    network:"https://github.com/suyashmahar/up_sources_stable.git"

# Load selected packages
up_load_package \
    cargo \
    conda
```

3. (Optional) You can create your own packages and load them:
<details>
You can create your own packages using use-package's syntax. To create a new package, modify the following template on disk:
</details>

And, voila your .${SHELL}rc is ready!

Your shell's rc file should look like:
insert image here

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
