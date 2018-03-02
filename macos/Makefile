################################################################################
# Makefile for installing mac settings
################################################################################

all: xcode homebrew fonts

xcode: xcode.sh
    ./xcode.sh

homebrew: homebrew.sh brew.sh cask.sh
    ./homebrew.sh
    ./brew.sh
    ./cask.sh

fonts: fonts.sh
	./fonts.sh

editors: iterm.sh pycharm.sh sublime.sh
	./iterm.sh
	./pycharm.sh
	./sublime.sh
