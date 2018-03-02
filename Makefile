################################################################################
# Dotfig top-level Makefile
################################################################################

all: macos python lisp dotfiles

macos: macos/Makefile
    make -C macos

python: python/Makefile
    make -C python

lisp: lisp/Makefile
    make -C lisp

dotfiles: dotfiles/Makefile
    make -C dotfiles
