note
	description: "Summary description for {USER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	USER

inherit
	HASHABLE
		undefine
			out, is_equal
		end
	COMPARABLE
		redefine
			is_equal, out
		end

create
	make_empty,
	new_user


feature -- creation
	make_empty
		do
			create name.make_empty
			create uid.make_empty

			create group_subs.make (10)
			create message_list.make_empty

			create sorted_group_ids.make

			mcounter := 0
			gcounter := 0
		end

	new_user(a_user: STRING; a_uid : ID)
		require
			name_valid: a_user.at (1).is_alpha
		do
			name := a_user
			uid	 := a_uid

			gcounter := 0
			mcounter := 0

			create uid.make_empty
			create group_subs.make (10)
			create message_list.make_empty

			create sorted_group_ids.make

		ensure
			user_recorded: name = a_user
		end

feature -- queries
	name			: 	STRING
	uid				: 	ID

	group_subs 		: 	HASH_TABLE[GROUP,ID]
	gcounter 		: 	INTEGER

	sorted_group_ids 	: SORTED_TWO_WAY_LIST [ID]

	mcounter 		: 	INTEGER
	message_list	:	ARRAY[MESSAGE]

feature -- commands/queries
	set_id(a_uid : ID)
		do
			uid := a_uid
		end

	register_group_sub(a_group: GROUP; a_gid : ID)
		do
			group_subs.force (a_group, a_gid)
		end

	group_sub_exists(a_gid : ID) : BOOLEAN
		do
			Result := group_subs.has (a_gid)
		end
	increment_counter
		do
			mcounter := mcounter + 1
		end

	privacy_check(a_message : MESSAGE) : BOOLEAN
		do
			if a_message.status ~ "unavailable" then
				Result := message_list.has (a_message)
			end
		end

	message_at (a_mid : INTEGER_64) : MESSAGE
		local
			j 				: INTEGER
			temp 			: MESSAGE
		do
			create temp.make_empty
			Result := temp
			from
				j := 1
			until
				j > message_list.count
			loop
				if message_list.at (j).message_id = a_mid then
					Result := message_list.item (j)
				end
				j := j + 1
			end
		end

	print_all_messages : STRING
		local
			j  : INTEGER
		do
			create Result.make_from_string ("")
			if mcounter > 0 then
				from
					j := 1
				until
					j > message_list.count
				loop
					Result.append ("      ")
					Result.append(message_list.at (j).print_status (uid))
					Result.append("%N")
					j := j + 1
				end
			end
		end

	print_message_at (index : INTEGER) : STRING
		do
			create Result.make_from_string ("")
			if index <= mcounter then
				Result.append ("      ")
				Result.append(message_list.at (index).print_status (uid))
				Result.append("%N")
			end
		end

	print_subs : STRING
		local
			group 	: GROUP
		do
			create Result.make_from_string ("")
			if not group_subs.is_empty then
				Result.append("      [")
				Result.append(uid.out)
				Result.append(", ")
				Result.append(name)
				Result.append("]->{")
					from
						sorted_group_ids.start
					until
						sorted_group_ids.after
					loop
						Result.append(sorted_group_ids.item_for_iteration.out)
						Result.append("->")
						group := group_subs.item (sorted_group_ids.item)
						check attached group as g then
							Result.append(group.name)
						end
						sorted_group_ids.forth
						if not sorted_group_ids.after then
							Result.append(", ")
						end
					end
				Result.append("}")
				Result.append ("%N")
			end
		end

	print_user_and_id : STRING
		do
			create Result.make_from_string ("")
			if not group_subs.is_empty then
				Result.append("[")
				Result.append(uid.out)
				Result.append(", ")
				Result.append(name)
				Result.append("]")
			end
		end

	print_users : STRING
		do
			create Result.make_from_string ("  ")
			Result.append (uid.out)
			Result.append ("->")
			Result.append (name)
		end

feature -- redef
	out: STRING
		do
			create Result.make_from_string ("")
			Result.append (uid.out)
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := uid ~ other.uid and name ~ other.name
		ensure then
			Result = (name ~ other.name and uid ~ other.uid)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if name < other.name then
				Result := true
			elseif name ~ other.name and uid < other.uid then
				Result := true
			else
				Result := false
			end
		ensure then
			Result = (name < other.name) or (name ~ other.name and uid < other.uid)
		end

	hash_code: INTEGER
		do
		 	Result := 2
		end

end
