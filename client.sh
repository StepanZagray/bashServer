#!/bin/bash

# Check if id parameter is provided
if [ $# -eq 0 ]; then
    echo "ERROR: No user id provided"
    exit 1
fi

id="$1"
client_pipe="${id}.pipe"
server_pipe="server.pipe"

# Create client's named pipe
if [ ! -p "$client_pipe" ]; then
    mkfifo "$client_pipe"
fi

# Ensure server pipe exists (wait for server to create it)
if [ ! -p "$server_pipe" ]; then
    echo "ERROR: Server pipe not found. Please start the server first."
    exit 1
fi

# Cleanup function to remove named pipe on exit
cleanup() {
    if [ -p "$client_pipe" ]; then
        rm -f "$client_pipe"
    fi
    exit 0
}

# Trap Ctrl+C and cleanup
trap cleanup SIGINT SIGTERM

# Main loop
while true; do
    # Read request from user
    read -p "Enter request (create/add/post/display): " request
    
    # Check if request is empty
    if [ -z "$request" ]; then
        continue
    fi
    
    # Parse request to check if it's well-formed
    req=$(echo "$request" | cut -d' ' -f1)
    args=$(echo "$request" | cut -d' ' -f2-)
    
    # Validate request format
    case "$req" in
        create|add|post|display)
            # Request is well-formed, send to server
            # Format: req id args
            full_request="$req $id $args"
            echo "$full_request" > "$server_pipe"
            
            # Read response from server
            response=$(cat "$client_pipe")
            
            # Display response in user-friendly way
            if echo "$response" | grep -q "^ok:"; then
                # Success message
                message=$(echo "$response" | sed 's/^ok: //')
                echo "SUCCESS: $message"
            elif echo "$response" | grep -q "^nok:"; then
                # Error message
                message=$(echo "$response" | sed 's/^nok: //')
                echo "ERROR: $message"
            elif echo "$response" | grep -q "start_of_file"; then
                # Display wall content (skip start_of_file and end_of_file lines)
                echo "$response" | sed '/^start_of_file$/d; /^end_of_file$/d'
            else
                # Other responses (shouldn't happen, but handle gracefully)
                echo "$response"
            fi
            ;;
        *)
            echo "ERROR: Invalid request. Use: create, add, post, or display"
            ;;
    esac
done

