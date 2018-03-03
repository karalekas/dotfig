# dotfig

Easy dotfile and configuration management!

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
