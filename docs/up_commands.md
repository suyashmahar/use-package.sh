use-package.sh Commands
=============================



## SHELL COMMANDS  

To use these commands, either make sure that the use-package is loaded
with your shell's rc or that you manually source it. 

These commands can be called directly from the shell or from the
shell's rc file.

### up_create_pkg
Parameters: <pkg_name> <pkg_short_desc> <pkg_version>  

Command to create a up package. This command should be executed from a
directory that contains a `package.list` file and a `packages`
directory.
The command will interactively ask for missing positional parameter.


### up_list_pkgs

Lists all the packages across all the sources available in UP's 
cache.  


### up_load_sources  
Parameters: <src> [<src> [...]]

Loads one or more packages by looking them up and copying them to UP's
local cache.  
<src> should following the following covention:  

```
type:path  
```

Where, <type> could be one of `git`, `network` or `local`. And, <path>
should be a string to locate resource of corresponding type.  

Description of each source type available with UP:  

* `git`: A git repository, local or remote. UP clones the path using
  `git clone`.  
* `network`: A network directory. UP retreives the location using
   wget(1).  
* `local`: A local directory. UP retreives it using cp(1).  

For example, the offical stable upstream is represented as:

```
git:"https://github.com/suyashmahar/up_sources_stable.git"
```

### up_load_package  
Parameter: <pkg> [<pkg> [...]]  

UP loads each of the listed packages by searching in all the locally
available sources.

### up_load_pkg_loc  

Parameter: <path>

Loads a package from the specified file system location. <path> should
point to a `pkg.up.sh` file.

### up_locate_pkg  

### up_install  

### up_help  

## UP PACKAGE API

### up_ensure

### up_notify_done

### up_fatal

### up_nop

### up_say

### up_verbose

### up_warn


## UNDECIDED

### up_check

### up_check_pkg
