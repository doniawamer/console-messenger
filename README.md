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

<b>Commands and Queries:</b><br>
Adding a user:<br> 
&nbsp;&nbsp;add_user(UID,"NAME")<br>

Adding groups:<br> 
&nbsp;&nbsp;add_group(GID,"NAME")<br>

Registering a user:<br> 
&nbsp;&nbsp;register_user(UID,GID)<br>

Sending messages:  
&nbsp;&nbsp;send_message(UID,GID,"MESSAGE")<br>

Listing old and new messages:<br>
&nbsp;&nbsp;list_new_messages(UID)<br>
&nbsp;&nbsp;list_old_messages(UID)<br>

Listing groups and users:<br>  
&nbsp;&nbsp;list_groups	<br>
&nbsp;&nbsp;list_users<br>

Setting preview length:<br> 
&nbsp;&nbsp;set_message_preview(n)<br>

Reading messages:<br> 
&nbsp;&nbsp;read_message(UID,MID)<br>

Deleting messages:<br> 
&nbsp;&nbsp;delete_message(UID,MID)<br>
<br>
(*) For examples check out /tests/acceptance/student/at*.txt
