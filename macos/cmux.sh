#!/bin/sh
###############################################################################
# Usage: cmux.sh
#
# Change cmux settings that it saves in macOS preferences instead of reading
# from cmux.json
#
# Order: After installing cmux
#
# Requires: None
###############################################################################

# hide the workspace title bar; cmux 0.64 ignores app.minimalMode in cmux.json
if [ "`defaults read com.cmuxterm.app workspacePresentationMode 2>/dev/null`" = minimal ]
then
    echo "workspacePresentationMode is already set to minimal, continuing..."
else
    echo "Setting workspacePresentationMode to minimal..."
    defaults write com.cmuxterm.app workspacePresentationMode minimal
fi
