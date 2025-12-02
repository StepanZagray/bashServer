#!/bin/bash

sender="$1"
receiver="$2"
# Get all remaining parameters as the message
shift 2
message="$*"

# Check if sender exists
if [ ! -d "users/$sender" ]; then
    echo "nok: user '$sender' does not exist"
    exit 1
fi

# Check if receiver exists
if [ ! -d "users/$receiver" ]; then
    echo "nok: user '$receiver' does not exist"
    exit 1
fi

# Acquire lock for receiver's wall to prevent concurrent posts
./acquire.sh "wall_${receiver}"

# Check if sender is a friend of receiver
if ! grep "^$sender$" "users/$receiver/friends.txt" > /dev/null 2>&1; then
    ./release.sh "wall_${receiver}"
    echo "nok: user '$sender' is not a friend of '$receiver'"
    exit 1
fi

# Post message to receiver's wall
echo "$sender: $message" >> "users/$receiver/wall.txt"

# Release lock
./release.sh "wall_${receiver}"

echo "ok: message posted!"

