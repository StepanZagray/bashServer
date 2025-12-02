#!/bin/bash

id="$1"
friend="$2"

# Check if user exists
if [ ! -d "users/$id" ]; then
    echo "nok: user '$id' does not exist"
    exit 1
fi

# Check if friend exists
if [ ! -d "users/$friend" ]; then
    echo "nok: user '$friend' does not exist"
    exit 1
fi

# Acquire locks for both friend lists to prevent race conditions
# Lock in alphabetical order to avoid deadlock
if [ "$id" \< "$friend" ]; then
    ./acquire.sh "friends_${id}"
    ./acquire.sh "friends_${friend}"
    lock1="friends_${id}"
    lock2="friends_${friend}"
else
    ./acquire.sh "friends_${friend}"
    ./acquire.sh "friends_${id}"
    lock1="friends_${friend}"
    lock2="friends_${id}"
fi

# Function to release locks in reverse order
release_locks() {
    ./release.sh "$lock2"
    ./release.sh "$lock1"
}

# Check if friendship already exists in both directions
friend_in_id_list=false
id_in_friend_list=false

if grep "^$friend$" "users/$id/friends.txt" > /dev/null 2>&1; then
    friend_in_id_list=true
fi

if grep "^$id$" "users/$friend/friends.txt" > /dev/null 2>&1; then
    id_in_friend_list=true
fi

# If both friendships already exist, they're already mutual friends
if [ "$friend_in_id_list" = true ] && [ "$id_in_friend_list" = true ]; then
    release_locks
    echo "ok: friend added!"
    exit 0
fi

# Add friend to id's friends list if not already there
if [ "$friend_in_id_list" = false ]; then
    echo "$friend" >> "users/$id/friends.txt"
fi

# Add id to friend's friends list if not already there (make it mutual)
if [ "$id_in_friend_list" = false ]; then
    echo "$id" >> "users/$friend/friends.txt"
fi

# Release locks
release_locks

echo "ok: friend added!"

