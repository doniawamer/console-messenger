# console-messenger

<b>How to run commands in interactive mode (Unix):</b>
1. Open terminal 
2. cd *directory*
3. Messenger-exe.exe -i
4. Enter legal commands 


<b>How to run commands from a text file (Unix):</b>
1. Open terminal 
2. cd *directory*
4. nano *text file* (or alternatively your editor of choice) 
5. Enter legal commands 
3. messenger-exe.exe -b *text file*

<b>Commands and Queries:</b>
-- Adding a user:<br> 
add_user(UID,"NAME")

-- Adding groups:<br> 
add_group(GID,"NAME")

-- Registering a user:<br> 
register_user(UID,GID)

-- Sending messages:<br>  
send_message(UID,GID,"MESSAGE")

-- Listing old and new messages:<br> 
list_new_messages(UID)
list_old_messages(UID)

-- Listing groups and users:<br>  
list_groups				
list_users

-- Setting preview length:<br> 
set_message_preview(n)

-- Reading messages:<br> 
read_message(UID,MID)

-- Deleting messages:<br> 
delete_message(UID,MID)

(*) For examples check out /tests/acceptance/student/at*.txt
