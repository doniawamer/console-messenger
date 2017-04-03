note
	description: "Summary description for {MESSAGE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MESSAGE_LIST
inherit
	ANY
		redefine
			 out
		end

create
	make_empty,
	new_message_list


feature -- creation
	make_empty
		do
			create message_list.make_empty
			create message_ids.make_empty
			mcounter := 0
		end

	new_message_list(a_message : MESSAGE)
		do
			create message_list.make_empty
			create message_ids.make_empty
			mcounter := mcounter + 1

			message_list.force (a_message,mcounter)
		end

feature -- queries
	message_list	: ARRAY[MESSAGE]
	message_ids		: ARRAY[INTEGER_64]
	mcounter		: INTEGER

feature -- commands/queires
	add_message(a_message : MESSAGE)
		do
			mcounter := mcounter + 1
			message_list.force (a_message,mcounter)
			message_ids.force(a_message.message_id ,mcounter)
		end

	print_message_at(j : INTEGER) : STRING
		do
			create Result.make_from_string ("")
			Result.append ("      ")
			Result.append (j.out)
			Result.append ("->")
			Result.append (message_list.at (j).print_message)
			Result.append ("%N")
		end

	set_preview_length(a_n : INTEGER_64)
		local
			j 	: INTEGER
		do
			from
				j := 1
			until
				j > message_list.count
			loop
				message_list.at (j).set_preview_length (a_n)
				j := j + 1
			end
		end

	preview_length : STRING
		do
			Result := message_list.at (mcounter).preview.out
		end


feature -- redef
	out: STRING
		local
			j 	: INTEGER
		do
			create Result.make_from_string ("")
			from
				j := 1
			until
				j > message_list.count
			loop
				Result.append ("      ")
				Result.append (j.out)
				Result.append ("->")
				Result.append (message_list.at (j).print_message)
				Result.append ("%N")
				j := j + 1
			end
		end

end
