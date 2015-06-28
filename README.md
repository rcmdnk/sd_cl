sd_cl
=====

Useful functions to change directories for Bash/Zsh and GNU screen/tmux.

## Installation

Get `sd_cl` and set to where you like,
then, call it from your `.bashrc` or `.zshrc` like

    source /path/to/sd_cl

:white_check_mark: current version requires [sentaku](https://github.com/rcmdnk/sentaku).

If you use Homebrew or cURL to insatll, sentaku will be installed automatically, too.

If you directly get the script, please install sentaku or use
[standalone version](https://github.com/rcmdnk/sd_cl/tree/standalone)
(standalone version could be obsolete).

### cURL

You can use an install script on the web like:

    $ curl -fsSL https://raw.github.com/rcmdnk/sd_cl/install/install.sh| sh

This will install scripts to `/usr/etc`
and you may be asked root password.

If you want to install other directory, do like:

    $ curl -fsSL https://raw.github.com/rcmdnk/sd_cl/install/install.sh|  prefix=~/usr/local/ sh

### Homebrew at OS X

On Mac, you can install scripts by [Homebrew](https://github.com/mxcl/homebrew):

    $ brew tap rcmdnk/rcmdnkpac
    $ brew install sd_cl

If you have [brew file](https://github.com/rcmdnk/homebrew-file), add following lines to Brewfile:

    tap 'rcmdnk/rcmdnkpac'
    brew 'sd_cl'

then, do:

    $ brew file install

Or if you write like:

    tapall 'rcmdnk/rcmdnkpac'

and do `brew file install`, you will have all useful scripts in
[rcmdnkpac](https://github.com/rcmdnk/homebrew-rcmdnkpac).

This installs `sd_cl` to `${HOMEBREW_PREFIX}/etc` (default: `/usr/local/etc/`).

### Download

Or, simply download scripts and set where you like.

:warning: Install [sentaku](https://github.com/rcmdnk/sentaku), too.

## Usage

### Main functions: sd/cl

`sd_cl` will load new functions:

* `sd` (save dirctory)
* `cl` (change to the last directory)

`sd` saves current directory to the directory history file.

If you give a directory name, it saves the given directory.

`cl` is used to change the directory to saved directories.

If it is called w/o arguments, you will move to the last saved directory by `sd`.


It is useful if you are working with GNU screen or tmux.
You can easily move to other window's directory.

* `sd` at Window 1 (e.g. directory: `~/usr/etc`).
* `cl` at Window 2, then you are in `~/usr/etc` at Window 2, too.

### Options for cl
Options for `cl` are here:

    -l          Show saved directories
    -c          Show saved directories and choose a directory
    -C          Clear directories
    <number>    Move to <number>-th last directory
    -n <number> Move to <number>-th last directory (obsolete)
    -N          No header for selection window
    -p          Move to pre-defiend dirctory in $PREDEFDIRFILE
    -w          Move to other window's (screen/tmux) dirctory in $WINDOWDIRFILE
    -v          Move from current directory, like Vim
    -h          Print this HELP and quit

`-l`, `-c`, `-C`, `-N` and `-n` (`<number>`) are used exclusively.

`-p` (pre-defined directory list) or `-w` (window directory list)
change the list file and can be used with other options.

e.x.) `cl -p 3` moves to the 3rd directory stored in pre-defined directory list.

### Saved directory list and cl selection mode example

If you work w/o `-p` or `-w`, `cl` uses saved (by `sd`) directory list.

If you use `-c`, `cl` starts selection mode. See below demo.

> [sd_cl demo in asciinema](http://asciinema.org/a/6904)

In the selection mode, you can use:

* j: Select 1 down.
* [n]j: Select [n] below. e.g.: 11j: Select 11th below.
* k: Select 1 up.
* [n]k: Select [n] up.
* d: Delete selected directory.
* gg: Select 1st directory.
* G: Select the last directory.
* [n]gg/G: Select n-th directory.
* Enter: Go to selected directory and quit.
* q: Quit.

### Pre-defined directory list

If you use `-p`, it uses `pre-defined` directory list, which is not changed by `sd`.

In normal selection mode (i.e. `cl -c`), you can select and put the directory
to the `pre-defined` directory list (use `p` in the mode).

### Window directory list

If you are working in GNU screen or tmux, each window's directory is saved automatically.
You can change a directory to there by using `-w` option.

It shows `window_number` `pane_number` (always 0 for GNU screen) and directory.

You can select only with `window_number` or `window_number`+`pane_number`, too.

e.g.:

    $ cl -w 3

This command change the directory to the directory of Window 3.
If it has several panes, it chooses the directory of the first pane.

### Vim like file explorer

Option `-v` will give you the continuous selection mode to change the directory,
like vim file explorer.

### Tab completion

Tab completion is available both for Bash and Zsh.

    $ cl [Tab] # Completion with saved directory list.
    $ cl -p [Tab] # Completion with pre-defined directory list.
    $ cl -w [Tab] # Completion with window directory list.

If you give directory name to `cl`, you will just move to the directory like normal `cd`.

### Bonus alias/functions

* bd (back to directory): alias for to `popd >/dev/null`
* cd : `cd` is wrapped with `popd`. Useful to use with `bd`.
* cdpwd : works as `cd -P .`, i.e. resolves symbolic links in the path.

## Options

Following options can be set before sourcing `sd_cl` in `.bashrc` or `.zshrc`.

    # Directory store file
    export LASTDIRFILE=${LASTDIRFILE:-$HOME/.lastDir}
    export PREDEFDIRFILE=${PREDEFDIRFILE:-$HOME/.predefDir}
    export WINDOWDIRFILE=${WINDOWDIRFILE:-$HOME/.windowDir}

    # Number of store directories
    export NLASTDIR=${NLASTDIR:-20}
    
    # post cd (overwrite cd (Bash) or chpwd (Zsh)
    export ISPOSTCD=${ISPOSTCD:-1}
    
    # COMPLETION
    export NOCOMPLETION=${NOCOMPLETION:-0}
    export NOCOMPINIT=${NOCOMPLETION:-0}
    
    # cd wrap to pushd/popd
    export ISCDWRAP=${ISCDWRAP:-1}

First three values set directory list files for `saved`, `pre-defined` and `window`.

You can set maximum number of saved directories by `NLASTDIR` (default 20).

If you set `ISPOSTCD` to 0, it doesn't save window's directory
in GNU screen or tmux.

If you set `NOCOMPLETION` to 1, completion will be disabled.

For Zsh user, if you already initialized completions with `compinit`,
please set `export NOCOMPINIT=1`.
Otherwise `sd_cl` execute:


    autoload -Uz compinit
    compinit

If you don't want to wrap `cd` with `pushd`, set `ISCDWRAP` to 0.


If you already have wrapper function for `cd` or the setting for `chpwd` at Zsh,
you should be better to set:

    export ISPOSTCD=0 # Don't do automatic save
    export ISCDWRAP=0 # Don't wrap for pushd

Otherwise `sd_cl` overwrites these functions.

If you want to have automatic save in GNU screen/tmux with your `cd`/`chpwd`,
first, set above ISPOSTCD and ISCDWRAP as 0 to disable to wrap in `sd_cl`,
then call `post_cd` in your `cd` function for Bash like:

    builtin cd "$@"
    local ret=$?
    if [ $ret -eq 0 ];then
      post_cd
    fi
    return $ret

or simply call `post_cd` in `chpwd` for Zsh case.

If you want to enable pushd wrap in your `cd` function,
replace your `builtin(command) cd` command with

    wrap_cd "$@"

i.e., if you want to enable both in Bash, you should replace above `builtin cd "$@"`
with `wrap_cd "$@"`.


## References

* [ターミナルでのディレクトリ移動を保存、取り出しする](http://rcmdnk.github.io/blog/2013/12/27/computer-bash-zsh-sd-cl/)
