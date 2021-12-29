<p align="center">
  <img height="200" src="assets.github/banner.svg">
</p>

[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)

# use-package.sh
A package manager for your shellrc to keep it clutter free. `use-package.sh`
separates configuration for different applications into packages. Each package
makes it easier to configure an application, or install it, if it's missing on
the system.

## What Does `use-package.sh` do?
* Install all your tools on a new machine when you clone your RC files.
* Keep your rc file clean. No more rc files with 100s of complicated shell stuff.
* Organize shell commands for applications into separate packages. Share stuff
  with others or use use-package's stable sources.

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

2. You'd then need to specify your sources and the packages that you want to
   enable:

```shell
# Enable use-package.sh's default source
up_load_sources \
    git:"https://github.com/suyashmahar/up_sources_stable.git"

# Load selected packages
up_load_pkgs \
    cargo \
    conda3
```

3. (Optional) You can create your own packages and load them:
<details>
<hr>

To create a new package, you'd first need to create your
own source using the command `up_create_source`. This will
create a new source in the current directory. You'd want to 
store this package in a git repo.
        
Next step, create a new package using the command `up_create_pkg`.
        
To edit the newly create package, use the command `up_edit` to edit
this package.
<hr>
</details>

And, voila your .${SHELL}rc is ready!

Your shell's rc file should look like:  
insert image here

use-package.sh has more commands available, checkout `up_help`

## Packages available
The following packages are available in use-package.sh's [default
respository](https://github.com/suyashmahar/up_sources_stable)

### Common

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

## FAQ
1. **I don't want to execute code from the internet**  
Sure thing, you can run use-package-setup.sh to do everything offline. This
however will require few extra steps, check the wiki for setting up your own
source.
2. **Does it support my shell?**  
use-package.sh is written ground up to be POSIX compliant. If your shell support
POSIX commands, use-package.sh will work.
