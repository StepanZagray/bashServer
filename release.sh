#!/bin/bash

# release.sh - Release a lock
# Usage: ./release.sh lockname
# Removes the lock file

lockname="$1"

if [ -z "$lockname" ]; then
    echo "ERROR: Lock name not provided"
    exit 1
fi

lockfile="locks/${lockname}.lock"

# Remove lock if it exists
if [ -d "$lockfile" ]; then
    rmdir "$lockfile" 2>/dev/null
fi

exit 0

