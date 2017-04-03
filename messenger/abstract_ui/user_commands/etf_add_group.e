note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_GROUP
inherit
	ETF_ADD_GROUP_INTERFACE
		redefine add_group end
create
	make

feature -- queries
	error : BOOLEAN

feature -- command
	add_group(gid: INTEGER_64 ; group_name: STRING)
		require else
			add_group_precond(gid, group_name)
    	do
    		err_id_negative(gid)
			err_id_used(gid)
    		err_name(group_name)

			if not error then
				model.add_group (gid, group_name)
			end
			etf_cmd_container.on_change.notify ([Current])
    	end

feature -- error gen
	err_id_negative(a_id : INTEGER_64)
		do
			if 	a_id <= 0 and not error then
				model.error_message ("  ID must be a positive integer.")
				error := true
			end
		end

	err_id_used(a_id : INTEGER_64)
		do
			if not error then
				if 	model.gid_exists (a_id)  then
					model.error_message ("  ID already in use.")
					error := true
				end
			end
		end

	err_name(a_group_name : STRING)
		do
			if 	not model.name_valid (a_group_name) and not error then
				model.error_message ("  Group name must start with a letter.")
				error := true
			end
		end
end
