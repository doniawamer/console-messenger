note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_OLD_MESSAGES
inherit
	ETF_LIST_OLD_MESSAGES_INTERFACE
		redefine list_old_messages end
create
	make

feature -- queries
	error : BOOLEAN

feature -- command
	list_old_messages(uid: INTEGER_64)
		require else
			list_old_messages_precond(uid)
    	do
    		err_id_negative(uid)
    		err_uid_not_used(uid)

    		if not error then
				model.list_old_messages (uid)
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

	err_uid_not_used(a_uid : INTEGER_64)
	do
		if not error then
			if 	not model.uid_exists (a_uid)  then
				model.error_message ("  User with this ID does not exist.")
				error := true
			end
		end
	end

end
