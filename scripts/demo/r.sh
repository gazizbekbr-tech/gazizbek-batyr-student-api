#!/bin/bash
# Runs each argument as a demonstrated command inside the project directory.
exec 2>&1
source "$(dirname "$0")/_demo.sh"
cd "$(dirname "$0")/../gazizbek-batyr-student-api" || exit 1
for c in "$@"; do
    case "$c" in
        "## "*) section "${c#\#\# }" ;;
        *) run "$c" ;;
    esac
done
