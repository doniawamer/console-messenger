note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_READ_MESSAGE
inherit
	ETF_READ_MESSAGE_INTERFACE
		redefine read_message end
create
	make

feature -- queries
	error : BOOLEAN

feature -- command
	read_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require else
			read_message_precond(uid, mid)
    	do
    		err_id_negative(uid)
    		err_id_negative(mid)
    		err_uid_not_used(uid)
    		err_mid_not_used(mid)
    		err_user_authorization(uid,mid)
			err_message_deleted(uid,mid)
			err_message_read(uid,mid)

			if not error then
				model.read_message (uid, mid)
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

		err_mid_not_used(a_mid : INTEGER_64)
			do
				if not error then
					if 	not model.message_id_valid (a_mid) then
						model.error_message ("  Message with this ID does not exist.")
						error := true
					end
				end
			end

		err_user_authorization(a_uid: INTEGER_64; a_mid : INTEGER_64)
			do
				if not error then
					if  (model.message_status (a_uid, a_mid) ~ "unavailable") and not(model.deleted_message (a_uid, a_mid)) then
						model.error_message ("  User not authorized to access this message.")
						error := true
					end
				end
			end

		err_message_read(a_uid: INTEGER_64; a_mid : INTEGER_64)
			do
				if not error then
					if  model.message_status (a_uid, a_mid) ~ "read" then
						model.error_message ("  Message has already been read. See `list_old_messages'.")
						error := true
					end
				end
			end

		err_message_deleted(a_uid: INTEGER_64; a_mid : INTEGER_64)
			do
				if not error then
					if  model.deleted_message (a_uid, a_mid) then
						model.error_message ("  Message with this ID unavailable.")
						error := true
					end
				end
			end

end
