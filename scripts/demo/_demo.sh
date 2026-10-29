#!/bin/bash
# Helper for terminal demonstrations: prints a shell prompt + the command, then runs it.
run() {
    local dir="${PWD##*/}"
    [ "$PWD" = "$HOME" ] && dir="~"
    printf '\n%s@%s:%s$ %s\n' "$(whoami)" "$(hostname -s)" "$dir" "$*"
    eval "$@"
}
section() {
    printf '\n==================== %s ====================\n' "$*"
}
