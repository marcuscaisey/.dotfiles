#!/usr/bin/env bash

# Convenience script for restowing all of the config in the stow directory so
# that you don't have to run install.sh to add new config.
#
stow -vv --target ~ --dir ~/.dotfiles --restow stow
