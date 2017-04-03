note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SEND_MESSAGE
inherit
	ETF_SEND_MESSAGE_INTERFACE
		redefine send_message end
create
	make
feature -- queries
	error : BOOLEAN

feature -- command
	send_message(uid: INTEGER_64 ; gid: INTEGER_64 ; txt: STRING)
		require else
			send_message_precond(uid, gid, txt)
    	do

			err_id_negative(uid)
			err_id_negative(gid)
			err_uid_not_used(uid)
			err_gid_not_used(gid)
			err_message(txt)
			err_not_authorized(uid,gid)

			if not error then
				model.send_message (uid, gid, txt)
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

		err_message(a_txt : STRING)
			do
				if 	not (a_txt.at (1).is_alpha) and not error then
					model.error_message ("  A message may not be an empty string.")
					error := true
				end
			end

		err_not_authorized(uid: INTEGER_64 ;gid: INTEGER_64)
			do
				if not error and then (not model.group_sub_exists (uid, gid))  then
				model.error_message ("  User not authorized to send messages to the specified group.")
				error := true
				end
			end

end
