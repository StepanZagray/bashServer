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

# Check if sender is a friend of receiver
if ! grep "^$sender$" "users/$receiver/friends.txt" > /dev/null 2>&1; then
    echo "nok: user '$sender' is not a friend of '$receiver'"
    exit 1
fi

# Post message to receiver's wall
echo "$sender: $message" >> "users/$receiver/wall.txt"

echo "ok: message posted!"

