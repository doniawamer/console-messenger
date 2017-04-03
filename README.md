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
-- adding a user
add_user(UID,"NAME")

-- adding groups
add_group(GID,"NAME")

-- registering a user
register_user(UID,GID)

-- sending messages 
send_message(UID,GID,"MESSAGE")

-- listing old and new messages
list_new_messages(UID)
list_old_messages(UID)

-- listing groups and users 
list_groups				
list_users

-- setting preview length 
set_message_preview(n)

-- reading messages
read_message(UID,MID)

-- deleting messages 
delete_message(UID,MID)

(*) For examples check out /tests/acceptance/student/at*.txt
