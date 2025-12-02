#!/bin/bash

server_pipe="server.pipe"

# Create server pipe if it doesn't exist
if [ ! -p "$server_pipe" ]; then
    mkfifo "$server_pipe"
fi

# Main server loop - read from server pipe
while true; do
    # Read request from server pipe
    if read -r request < "$server_pipe"; then
        # Parse the request: format is "req client_id args"
        cmd=$(echo "$request" | cut -d' ' -f1)
        client_id=$(echo "$request" | cut -d' ' -f2)
        args=$(echo "$request" | cut -d' ' -f3-)
        
        # Get client pipe for response
        client_pipe="${client_id}.pipe"
        
        # Process request and send response to client pipe
        case "$cmd" in
            create)
                # For create: args is the new user id to create
                id=$(echo "$args" | cut -d' ' -f1)
                if [ -z "$id" ]; then
                    echo "nok: bad request" > "$client_pipe"
                else
                    ./create.sh "$id" > "$client_pipe"
                fi
                ;;
            add)
                # For add: client_id is the user, args is the friend to add
                friend=$(echo "$args" | cut -d' ' -f1)
                if [ -z "$client_id" ] || [ -z "$friend" ]; then
                    echo "nok: bad request" > "$client_pipe"
                else
                    ./add_friend.sh "$client_id" "$friend" > "$client_pipe"
                fi
                ;;
            post)
                # For post: client_id is the sender, args[1] is receiver, args[2+] is message
                receiver=$(echo "$args" | cut -d' ' -f1)
                message=$(echo "$args" | cut -d' ' -f2-)
                if [ -z "$client_id" ] || [ -z "$receiver" ] || [ -z "$message" ]; then
                    echo "nok: bad request" > "$client_pipe"
                else
                    ./post_messages.sh "$client_id" "$receiver" "$message" > "$client_pipe"
                fi
                ;;
            display)
                # For display: args is the user whose wall to display
                id=$(echo "$args" | cut -d' ' -f1)
                if [ -z "$id" ]; then
                    echo "nok: bad request" > "$client_pipe"
                else
                    ./display_wall.sh "$id" > "$client_pipe"
                fi
                ;;
            *)
                echo "nok: bad request" > "$client_pipe"
                ;;
        esac
    fi
done

