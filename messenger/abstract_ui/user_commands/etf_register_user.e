note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REGISTER_USER
inherit
	ETF_REGISTER_USER_INTERFACE
		redefine register_user end
create
	make

feature -- queries
	error : BOOLEAN

feature -- command
	register_user(uid: INTEGER_64 ; gid: INTEGER_64)
		require else
			register_user_precond(uid, gid)
    	do
    		err_id_negative(uid)
    		err_id_negative(gid)
    		err_uid_not_used(uid)
    		err_gid_not_used(gid)
    		err_sub_exists(uid,gid)

    		if not error then
				model.register_user (uid, gid)
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

		err_gid_not_used(a_gid : INTEGER_64)
			do
				if not error then
					if 	not model.gid_exists (a_gid)  then
						model.error_message ("  Group with this ID does not exist.")
						error := true
					end
				end
			end

	err_sub_exists(uid : INTEGER_64; gid :INTEGER_64)
		do
			if not error and then  ( model.group_sub_exists (uid, gid))  then
				model.error_message ("  This registration already exists.")
				error := true
			end
		end
end
