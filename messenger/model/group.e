note
	description: "Summary description for {GROUP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GROUP
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
	new_group

feature -- creation
	make_empty
		do
			create name.make_empty
			create gid.make_empty

			create user_subs.make (10)
			create message_list.make_empty

			mcounter := 0
			ucounter := 0
		end

	new_group(a_group: STRING; a_gid : ID)
		require
			name_valid: a_group.at (1).is_alpha
		do
			name := a_group
			gid	 := a_gid

			ucounter := 0
			mcounter := 0

			create gid.make_empty
			create user_subs.make (10)
			create message_list.make_empty

		ensure
			user_recorded: name = a_group
		end

feature -- queries
	name			: 	STRING
	gid				: 	ID

	user_subs 		: 	HASH_TABLE[USER,ID]
	ucounter 			: 	INTEGER

	mcounter 			: 	INTEGER
	message_list	:	ARRAY[MESSAGE]


feature -- queries


feature -- commands/queries
	set_id(a_gid : ID)
		do
			gid := a_gid
		end

	register_user_sub(a_user: USER; a_uid : ID)
		do
			user_subs.force (a_user, a_uid)
		end

	user_sub_exists(a_uid: ID) : BOOLEAN
		do
			Result := user_subs.has (a_uid)
		end


	print_groups : STRING
		do
			create Result.make_from_string ("  ")
			Result.append (gid.out)
			Result.append ("->")
			Result.append (name)
		end

feature -- redef
	out: STRING
		do
			create Result.make_from_string ("")
			Result.append (gid.out)
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := gid ~ other.gid and name ~ other.name
		ensure then
			Result = (name ~ other.name and gid ~ other.gid)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if name < other.name then
				Result := true
			elseif name ~ other.name and gid < other.gid then
				Result := true
			else
				Result := false
			end
		ensure then
			Result = (name < other.name) or (name ~ other.name and gid < other.gid)
		end

	hash_code: INTEGER
		do
		 	Result := 3
		end

end
