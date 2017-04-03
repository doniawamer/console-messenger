note
	description: "Summary description for {MESSAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE
inherit
	ANY
		redefine
			 out
		end

create
	make_empty,
	new_message


feature -- creation
	make_empty
		do
			create message.make_empty
			create status.make_empty
			create u_sender.make_empty
			create g_reciever.make_empty
			message_id := 0
			preview := 0
			del_flag := false
		end

	new_message(uid: ID; gid: ID; a_message: STRING; a_message_id: INTEGER)
		require
			valid_message: message_is_valid(a_message)
		do
			message	:= a_message
			status 	:= ""
			u_sender   := uid
			g_reciever := gid
			message_id := a_message_id
			preview := 15
			del_flag := false
		ensure
		end

feature -- queries
	message		:	STRING
	status 		: 	STRING
	u_sender	:	ID
	g_reciever	: 	ID
	message_id	: 	INTEGER
	preview		: 	INTEGER_64
	del_flag	: 	BOOLEAN

feature -- queries/commands
	message_is_valid(a_name: STRING) : BOOLEAN
		do
			Result := true
			if  (a_name.is_empty) then
					Result := false
			end
		end


	print_status (a_uid : ID) : STRING
		do
			create Result.make_from_string ("")
			Result.append ("(")
			Result.append (a_uid.out)
			Result.append (", ")
			Result.append (message_id.out)
			Result.append (")->")
			Result.append (status)
		end

	print_message_with_id : STRING
		do
			create Result.make_from_string ("")
			Result.append ("[")
			Result.append (message_id.out)
			Result.append (", %"")
			Result.append (message)
			Result.append ("%"]")
		end
	print_message : STRING
		do
			create Result.make_from_string ("")
			Result.append ("[sender: ")
			Result.append(u_sender.out)
			Result.append(", group: ")
			Result.append(g_reciever.out)
			Result.append(", content: %"")
			if message.count > preview then
				Result.append(message.substring (1, preview.as_integer_32))
				Result.append ("...")
			else
				Result.append(message)
			end
			Result.append("%"]")
		end

feature -- commands
	read_message
		do
			status := "read"
		end

	unread_message
		do
			status := "unread"
		end

	unavailable_message
		do
			status := "unavailable"
		end

	set_reciever(a_gid :ID)
		do
			g_reciever := a_gid
		end
	get_reciever : ID
		do
			Result := g_reciever
		end

	set_preview_length(a_n : INTEGER_64)
		do
			preview := a_n
		end

	deleted
		do
			del_flag := true
		end
feature -- redef
	out: STRING
		do
			create Result.make_from_string ("")
			Result.append (message)
		end
end
