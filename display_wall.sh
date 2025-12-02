#!/bin/bash

id="$1"

# Check if user exists
if [ ! -d "users/$id" ]; then
    echo "nok: user '$id' does not exist"
    exit 1
fi

# Acquire lock for user's wall to ensure consistent reading
./acquire.sh "wall_${id}"

# Display wall content
echo "start_of_file"
cat "users/$id/wall.txt"
echo "end_of_file"

# Release lock
./release.sh "wall_${id}"

