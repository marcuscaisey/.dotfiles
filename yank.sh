#!/bin/bash
set -euo pipefail

# Copies stdin to clipboard using the OSC 52 escape sequence.
#
# From iTerm docs:
#
# OSC 52
# This is not a proprietary control sequence. It's probably your best choice
# since it'll work with other terminal emulators.
# To write to the pasteboard:
#
# OSC 52 ; Pc ; [base64 encoded string] ST
#
# The Pc parameter is ignored. xterm uses it to choose among various
# clipboards, most of which do not exist in macOS.
#
#
# ESC means "Escape" (hex code 0x1b)
# ST means either BEL (hex code 0x07) or ESC \\.
# Spaces in control sequences are to be ignored.
# Values in [brackets] are variable parameters, not literals.
# OSC means ESC ]

if [[ -n ${TMUX:-} ]]; then
    # If we're in tmux, then we need to write the escape sequence to the tty of the active pane.
    active_pane_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
    printf $'\x1b]52;;%s\x07' "$(cat - | base64)" > $active_pane_tty
else
    printf $'\x1b]52;;%s\x07' "$(cat - | base64)"
fi
