# BashBook Part 2: Multi-User Client-Server System
## Project Report

---

### 1. Group Members

**Student 1:**
- Name: [Your Name]
- Student ID: [Your Student ID]

**Student 2:**
- Name: [Partner's Name]
- Student ID: [Partner's Student ID]

---

### 2. Use of GenAI Tools

We used AI coding tools (specifically Cursor AI) to help with this project. The AI helped us with:
- Getting started with the client-server architecture using named pipes
- Figuring out how to implement the locking mechanism for synchronization
- Setting up the code structure and error handling
- Writing the documentation and README

We reviewed, tested, and understood all the code ourselves. The AI was mainly useful for generating initial code and helping with structure, but we made all the design decisions, wrote the logic, and did all the testing ourselves.

---

### 3. Introduction

BashBook is a social networking system we built entirely using bash scripts. It works like a simple version of Facebook or Twitter, where multiple users can connect to a server at the same time and do things like create accounts, add friends, post messages, and view each other's walls.

We used named pipes (FIFOs) to let the clients and server talk to each other. All clients send their requests to one shared pipe, but each client gets their own pipe for responses so they don't see other people's messages. Since multiple users can be doing things at the same time, we needed a way to prevent conflicts. We solved this by using a directory-based locking system that stops race conditions and keeps the data consistent. This project was a great way to learn about inter-process communication, concurrent programming, and synchronization using shell scripting.

---

### 4. Implemented Features

We implemented seven main components:

1. **Client Script (client.sh)**: Accepts user ID, creates client pipe, reads requests interactively, sends `req id args` to server, formats responses (SUCCESS/ERROR), filters wall markers, and cleans up on exit.

2. **Server Script (server.sh)**: Listens on `server.pipe`, parses `req client_id args`, routes responses to `${client_id}.pipe`, handles create/add/post/display commands sequentially.

3. **User Management (create.sh)**: Creates user directories with `wall.txt` and `friends.txt`, prevents duplicates, uses locking.

4. **Friend Management (add_friend.sh)**: Adds mutual friendships, updates both friend lists atomically, uses dual locking.

5. **Message Posting (post_messages.sh)**: Posts to receiver's wall after validating friendship, uses wall locking.

6. **Wall Display (display_wall.sh)**: Shows wall content with locking for consistency, wraps output with markers.

7. **Synchronization (acquire.sh, release.sh)**: Directory-based locking with alphabetical ordering to prevent deadlocks.

---

### 5. Named Pipes Description

**Pipe Structure:**
- **server.pipe**: Single pipe where all clients send requests. The server doesn't know how many clients will connect, so one central pipe simplifies the design.
- **${id}.pipe**: Each client has their own response pipe (e.g., `alice.pipe`). This ensures privacy and prevents blocking.

**Design Choices:**
- Single server pipe allows dynamic client connections without the server needing advance knowledge.
- Per-client pipes provide privacy and non-blocking responses.
- Naming uses user ID directly (`${id}.pipe`) so the server can easily route responses by looking up `${client_id}.pipe`.

**Communication Flow:** Client → `server.pipe` → Server processes → `${client_id}.pipe` → Client

---

### 6. Locking Strategy

We use directory-based locks in `locks/`. Each lock is a directory - creating it acquires the lock; if it exists, someone else has it.

**6.1 Create Operation:** Lock `user_${id}` protects user creation. Prevents race conditions and partial user creation. Minimal performance impact since creation is infrequent and locks are held briefly.

**6.2 Add Friend Operation:** Locks `friends_${id1}` and `friends_${id2}` (alphabetically ordered). Must lock both lists since we update both files. Alphabetical ordering prevents deadlocks when two users add each other simultaneously. Slightly slower but necessary for correctness.

**6.3 Post Message Operation:** Lock `wall_${receiver}` protects the wall during writes. Prevents message corruption or loss. Only locks specific wall, allowing concurrent posts to different walls.

**6.4 Display Wall Operation:** Lock `wall_${id}` ensures consistent reads. Prevents reading half-written messages. Fast reads mean minimal performance impact.

**Overall Strategy:** Fine-grained locks per resource, short duration (only during file ops), alphabetical ordering prevents deadlocks, enables high concurrency.

---

### 7. Challenges Faced

1. **Named Pipe Communication:** Understanding how pipes work in client-server setup was tricky. Solved by using one `server.pipe` for requests and individual `${id}.pipe` for each client's responses.

2. **Request Parsing:** Client automatically adds its ID, making parsing confusing. Fixed with standard format `req client_id args` and careful `cut` usage.

3. **Synchronization and Deadlocks:** Hardest part - preventing deadlocks with multiple locks. Solved by always acquiring locks in alphabetical order.

4. **Response Formatting:** Client needs different formatting for success/error/wall content. Used `grep` to detect response type and format accordingly.

5. **Cleanup on Exit:** Named pipes stuck around after Ctrl+C. Added trap handlers to clean up pipes before exit.

6. **Lock Implementation:** Needed atomic locking with just bash/filesystem. Discovered `mkdir` is atomic - perfect for locking!

7. **Concurrent Testing:** Hard to test with multiple clients. Used multiple terminals doing simultaneous operations to verify locking.

8. **Code Redundancy:** Duplicate lock release code in add_friend.sh. Extracted into a function.

---

### 8. Conclusion

We successfully built a multi-user social networking system using bash scripts and named pipes. The system supports concurrent connections with proper synchronization.

**Key achievements:** Robust named pipe communication, effective locking preventing race conditions/deadlocks, user-friendly client interface, and proper cleanup.

**What we learned:** Inter-process communication with named pipes, concurrent programming and synchronization, client-server architecture, and filesystem-based locking.

The system handles edge cases well. Our fine-grained locking strategy maintains data consistency with good performance. Future improvements could include persistent storage, authentication, and enhanced error handling.

---

**Word Count:** Approximately 800 words


