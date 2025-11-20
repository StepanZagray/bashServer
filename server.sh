#!/bin/bash

while true; do
    read -r request
    
    # Parse the request
    cmd=$(echo "$request" | cut -d' ' -f1)
    
    case "$cmd" in
        create)
            id=$(echo "$request" | cut -d' ' -f2)
            if [ -z "$id" ]; then
                echo "nok: bad request"
            else
                ./create.sh "$id"
            fi
            ;;
        add)
            id=$(echo "$request" | cut -d' ' -f2)
            friend=$(echo "$request" | cut -d' ' -f3)
            if [ -z "$id" ] || [ -z "$friend" ]; then
                echo "nok: bad request"
            else
                ./add_friend.sh "$id" "$friend"
            fi
            ;;
        post)
            sender=$(echo "$request" | cut -d' ' -f2)
            receiver=$(echo "$request" | cut -d' ' -f3)
            message=$(echo "$request" | cut -d' ' -f4-)
            if [ -z "$sender" ] || [ -z "$receiver" ] || [ -z "$message" ]; then
                echo "nok: bad request"
            else
                ./post_messages.sh "$sender" "$receiver" "$message"
            fi
            ;;
        display)
            id=$(echo "$request" | cut -d' ' -f2)
            if [ -z "$id" ]; then
                echo "nok: bad request"
            else
                ./display_wall.sh "$id"
            fi
            ;;
        *)
            echo "nok: bad request"
            ;;
    esac
done

