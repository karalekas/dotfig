# dotfig

Dotfig is a one-stop shop for easy dotfile and configuration
management!

The steps are:
1. Install OS-specific settings ([macOS](#macos) or [Ubuntu](#ubuntu))
2. Install language-specific settings ([Python](#python) and [Lisp](#lisp))
3. Install dotfiles ([Dotfiles](#dotfiles))

## macOS

To set up your new Mac with dotfig, you first need to clone
the repository. However, this requires `git`, which will not
be initially installed on your machine. The easiest way to get
`git` on a Mac is by installing the XCode tools, which also
contain a ton of other useful command-line goodies. To install
the XCode tools, open the Terminal application and enter:

```bash
xcode-select --install
```

This installation should take a couple mins, and will require
you to enter your password for authentication. Once the
installation is complete, you'll need to clone dotfig. You
can do this with:

```bash
git clone --recurse-submodules https://github.com/pkaralekas/dotfig
```

It is important that you include `--recurse-submodules`, because
otherwise some of the code in dotfig will not be downloaded.

Within the top-level directory of dotfig, run `make macos`.
This will begin by installing [Homebrew](https://brew.sh/),
which is the unofficial package manager for macOS. After
installing Hombrew, this will continue by installing
a collection of brew formulae (e.g. `wget`) and cask apps
(e.g. `iterm2`) that are useful in any macOS environment.
To see the full list of packages and apps that will be
installed, check out the `brew-formulae` and `cask-formulae`
files in the `macos` subdirectory.

After the Homebrew stuff is complete (which will take 10-15
minutes), `make macos` will continue by running some scripts
to improve your terminal experience. This includes installing
the Deja Vu fonts, telling `iterm2` where to look for config
files (which will be installed in the [Dotfiles](#dotfiles)
section), speeding up the key rate of your keyboard, and
changing your shell to `zsh`.

## Ubuntu

To set up your new Ubuntu machine with dotfig, you first need
to clone the repository. However, this requires `git`, which
will not be initially installed on your machine. To get `git`
on your Ubuntu machine, do the following:

```bash
sudo apt-get install -y git
```

This installation will be very quick, and will require you
to enter your password for authentication. Once the
installation is complete, you'll need to clone dotfig. You
can do this with:

```bash
git clone --recurse-submodules https://github.com/pkaralekas/dotfig
```

It is important that you include `--recurse-submodules`, because
otherwise some of the code in dotfig will not be downloaded.

Within the top-level directory of dotfig, run `make ubuntu`.
This will install a collection of apt packages (e.g. `wget`)
that you will need in your Ubuntu environment. To see the
full list of packages that will be installed, check out the
`apt-packages` file in the `ubuntu` subdirectory.

## Python

From the top-level directory, run `make python`. This will
install `pyenv` on your computer, which is a great piece of
software for managing multiple versions of python and
virtual environments.

## Lisp

From the top-level directory, run `make lisp`. This will
install `quicklisp`, the package manager for Lisp, and
`expokit`, a matrix exponentiation library.

## Dotfiles

### Installing the dotfig dotfiles

From the top-level directory, run `make dotfiles`. This will
back up all your existing dotfiles to `~/.dotfig/backup` and
replace them with the dotfiles in the `dotfiles` subdirectory
of `dotfig`.

**NOTE**: This requires GNU `stow`. If you followed the macOS
instructions above, you should already have this installed.

### Uninstalling the dotfig dotfiles

From the `dotfiles` directory, run `make clean`. This will
remove all the dotfig-related dotfiles from your home
directory.

### Restoring your old dotfiles

**NOTE**: You must first uninstall the dotfig dotfiles.

From the `dotfiles` directory, run `make restore`. This will
copy all the dotfiles from the latest dotfig backup to your
home directory.
