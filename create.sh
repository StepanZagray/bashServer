#!/bin/bash

# Check if identifier is provided
if [ $# -eq 0 ]; then
    echo "nok: no identifier provided"
    exit 1
fi

id="$1"

# Create users directory if it doesn't exist
mkdir -p users

# Check if user already exists
if [ -d "users/$id" ]; then
    echo "nok: user already exists"
    exit 1
fi

# Create user directory
mkdir -p "users/$id"

# Create wall.txt file
touch "users/$id/wall.txt"

# Create friends.txt file
touch "users/$id/friends.txt"

echo "ok: user created!"

