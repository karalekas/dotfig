################################################################################
# Makefile for installing mac settings
################################################################################

.PHONY: all
all: homebrew terminal

.PHONY: homebrew
homebrew: homebrew.sh brew-formulae cask-formulae
	./homebrew.sh

.PHONY: terminal
terminal: fonts iterm keyboard

.PHONY: fonts
fonts: fonts.sh
	./fonts.sh

.PHONY: iterm
iterm: iterm.sh
	./iterm.sh

.PHONY: keyboard
keyboard: keyboard.sh
	./keyboard.sh
