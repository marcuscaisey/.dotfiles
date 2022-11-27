#!/bin/bash
# yk (yank) script - copy stdin to clipboard using osc52 escape sequence
set -euo pipefail

function print_OSC52() {
  esc="\033]52;c;$( printf %s "$1" | head -c $maxlen | base64 | tr -d '\r\n')\a"
  printf $esc
}

buf=$(cat "$@")
buf_len=${#buf}

maxlen=74994
if [[ $buf_len -gt $maxlen ]]; then
    >&2 echo "Input length ($buf_len) longer than max length ($maxlen), \
        output will be truncated"
fi

print_OSC52 "$buf"
>&2 echo "Copied $buf_len characters to clipboard"
