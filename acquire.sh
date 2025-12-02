#!/bin/bash

# acquire.sh - Acquire a lock
# Usage: ./acquire.sh lockname
# Creates a lock file and waits until it's available

lockname="$1"

if [ -z "$lockname" ]; then
    echo "ERROR: Lock name not provided"
    exit 1
fi

lockfile="locks/${lockname}.lock"

# Create locks directory if it doesn't exist
mkdir -p locks

# Wait until lock is available
while true; do
    if mkdir "$lockfile" 2>/dev/null; then
        # Successfully acquired lock
        exit 0
    else
        # Lock is held, wait a bit and try again
        sleep 0.1
    fi
done

