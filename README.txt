BashBook - Part 2: Multi-User Client-Server System
====================================================

This project implements a multi-user social networking system where multiple
clients can connect to a server simultaneously using named pipes for communication.

REQUIREMENTS
------------
- Bash shell (tested on Git Bash for Windows, should work on Linux/Mac)
- All scripts must be executable (chmod +x *.sh)

FILES INCLUDED
--------------
- server.sh          : Main server script that processes client requests
- client.sh          : Client script for user interaction
- create.sh          : Creates a new user account
- add_friend.sh      : Adds a friend relationship between two users
- post_messages.sh   : Posts a message to a user's wall
- display_wall.sh    : Displays a user's wall
- acquire.sh         : Lock acquisition script
- release.sh         : Lock release script

HOW TO RUN
----------

1. START THE SERVER
   -----------------
   Open a terminal and run:
   
   ./server.sh
   
   The server will create a named pipe called "server.pipe" and start listening
   for client requests. Keep this terminal open while the server is running.

2. START CLIENTS
   --------------
   Open separate terminals for each client. In each terminal, run:
   
   ./client.sh <user_id>
   
   For example:
   ./client.sh alice
   ./client.sh bob
   ./client.sh charlie
   
   Each client will create its own named pipe (<user_id>.pipe) for receiving
   responses from the server.

3. USING THE CLIENT
   -----------------
   Once a client is running, you can enter commands in the format:
   
   create <user_id>     - Create a new user account
   add <friend_id>      - Add a friend (uses your client's user_id)
   post <receiver_id> <message>  - Post a message to a friend's wall
   display <user_id>    - Display a user's wall
   
   Examples:
   - create dave
   - add bob
   - post bob Hello, how are you?
   - display bob
   
   The client automatically includes your user_id in requests, so you don't
   need to type it for add/post commands.

4. STOPPING THE SYSTEM
   --------------------
   - To stop a client: Press Ctrl+C in the client terminal
     (The client will automatically clean up its named pipe)
   
   - To stop the server: Press Ctrl+C in the server terminal
     (You may need to manually remove server.pipe if needed)

TESTING SCENARIO
----------------
1. Start the server: ./server.sh
2. In terminal 2: ./client.sh alice
3. In terminal 3: ./client.sh bob
4. In client alice: create alice
5. In client bob: create bob
6. In client alice: add bob
7. In client bob: add alice
8. In client alice: post bob Welcome to BashBook!
9. In client bob: display bob

NOTES
-----
- The server must be started before any clients
- Multiple clients can run simultaneously
- All user data is stored in the "users/" directory
- Lock files are stored in the "locks/" directory (created automatically)
- Named pipes are created automatically and cleaned up on client exit

TROUBLESHOOTING
---------------
- If you get "Server pipe not found": Make sure the server is running first
- If you get permission errors: Run chmod +x *.sh to make scripts executable
- If pipes are not working: Make sure you're using a Unix-like shell (bash)
- If locks are stuck: You can manually remove the locks/ directory
