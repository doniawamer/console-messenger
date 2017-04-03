note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_USER
inherit
	ETF_ADD_USER_INTERFACE
		redefine add_user end
create
	make

feature -- queries
	error : BOOLEAN

feature -- command
	add_user(uid: INTEGER_64 ; user_name: STRING)
		require else
			add_user_precond(uid, user_name)
    	do
			err_id_negative(uid)
			err_id_used(uid)
    		err_name(user_name)

    		if not error then
				model.add_user (uid, user_name)
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
				if 	model.uid_exists (a_id)  then
					model.error_message ("  ID already in use.")
					error := true
				end
			end
		end

		err_name(a_user_name : STRING)
		do
			if 	not model.name_valid (a_user_name) and not error then
				model.error_message ("  User name must start with a letter.")
				error := true
			end
		end

end
