#!/bin/sh
###############################################################################
# Usage: quicklisp.sh
#
# Install quicklisp
#
# Requires: curl, sbcl
###############################################################################

# install quicklisp
curl -o /tmp/quicklisp.lisp 'https://beta.quicklisp.org/quicklisp.lisp'
sbcl --noinform --non-interactive \
         --load /tmp/quicklisp.lisp \
         --eval '(quicklisp-quickstart:install)'

# add to sbclrc
echo >> ~/.sbclrc
echo '#-quicklisp(let ((i(merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))(when(probe-file i)(load i)))' >> ~/.sbclrc
echo '#+quicklisp(push "~/code" ql:*local-project-directories*)' >> ~/.sbclrc
rm -f /tmp/quicklisp.lisp

# update quicklisp
sbcl --eval "(ql:update-all-dists :prompt nil)" --quit