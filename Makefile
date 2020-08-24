################################################################################
# Dotfig top-level Makefile
################################################################################

.PHONY: all
all: macos python lisp dotfiles

.PHONY: centos
centos: centos/Makefile
	make -C centos

.PHONY: macos
macos: macos/Makefile
	make -C macos

.PHONY: ubuntu
ubuntu: ubuntu/Makefile
	make -C ubuntu

.PHONY: python
python: python/Makefile
	make -C python

.PHONY: lisp
lisp: lisp/Makefile
	make -C lisp

.PHONY: dotfiles
dotfiles: dotfiles/Makefile
	make -C dotfiles

.PHONY: editors
editors: editors/Makefile
	make -C editors
