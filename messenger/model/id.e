note
	description: "Summary description for {ID}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ID


inherit
	ANY
		undefine
			out
		redefine
			is_equal
		end
	HASHABLE
		undefine
			out, is_equal
		end
	COMPARABLE
		undefine
			out
		redefine
			is_equal, is_less
		end

create
	make_empty,
	new_id


feature -- creation
	make_empty
		do
			id := 0
		end

	new_id(a_id: INTEGER_64)
		do
			id := a_id
		ensure
			id_recorded: id = a_id
		end

feature -- queries
	id: INTEGER_64

feature -- commands
	get_id : INTEGER_64
		do
			Result := id
		end

feature -- redef
	out: STRING
		do
			create Result.make_from_string ("")
			Result.append (id.out)
		end

	hash_code: INTEGER
		do
		 	Result := 1
		end

	is_equal (other: like Current): BOOLEAN
			-- Is `other' value equal to current
		do
			Result := id ~ other.id
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if id < other.id then
				Result := true
			else
				Result := false
			end
		end

end

