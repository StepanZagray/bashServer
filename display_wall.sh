#!/bin/bash

id="$1"

# Check if user exists
if [ ! -d "users/$id" ]; then
    echo "nok: user '$id' does not exist"
    exit 1
fi

# Display wall content
echo "start_of_file"
cat "users/$id/wall.txt"
echo "end_of_file"

