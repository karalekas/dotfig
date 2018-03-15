################################################################################
# Makefile for installing mac settings
################################################################################

.PHONY: all
all: homebrew fonts

.PHONY: homebrew
homebrew: homebrew.sh brew-formulae cask-formulae
	./homebrew.sh

.PHONY: fonts
fonts: fonts.sh
	./fonts.sh

.PHONY: editors
editors: iterm.sh pycharm.sh sublime.sh
	./iterm.sh
	./pycharm.sh
	./sublime.sh
