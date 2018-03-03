################################################################################
# Makefile for installing mac settings
################################################################################

.PHONY: all
all: xcode homebrew fonts

.PHONY: xcode
xcode: xcode.sh
	./xcode.sh

.PHONY: homebrew
homebrew: homebrew.sh brew.sh cask.sh
	./homebrew.sh
	./brew.sh
	./cask.sh

.PHONY: fonts
fonts: fonts.sh
	./fonts.sh

.PHONY: editors
editors: iterm.sh pycharm.sh sublime.sh
	./iterm.sh
	./pycharm.sh
	./sublime.sh
