#!/bin/bash

# Check if identifier is provided
if [ $# -eq 0 ]; then
    echo "nok: no identifier provided"
    exit 1
fi

id="$1"

# Acquire lock for user creation to prevent race conditions
./acquire.sh "user_${id}"

# Check if user already exists
if [ -d "users/$id" ]; then
    ./release.sh "user_${id}"
    echo "nok: user already exists"
    exit 1
fi

# Create user directory
mkdir -p "users/$id"

# Create wall.txt file
touch "users/$id/wall.txt"

# Create friends.txt file
touch "users/$id/friends.txt"

# Release lock
./release.sh "user_${id}"

echo "ok: user created!"

