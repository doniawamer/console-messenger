note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	MESSENGER

inherit
	ANY
		redefine
			out
		end

create {MESSENGER_ACCESS}
	make

feature {NONE} -- Initialization
	make
		do
			create s.make_empty
			i := 0
			------
			create users_list.make (10)
			create sorted_users.make
			create sorted_user_ids.make

			create groups_list.make (10)
			create sorted_groups.make
			create sorted_group_ids.make

			create messages_list.make_empty
			create deb.make_empty
			create message.make_empty
			create status.make_from_string ("  ")
			status := "OK"

			ccounter := 0
			mcounter := 0

		end

feature --	user commands

	add_user(uid: INTEGER_64 ; user_name: STRING)
		require
			postive_id : uid > 0
			id_not_used : not uid_exists(uid)
			name_valid : name_valid(user_name)
		local
			id 		: ID
			user	: USER
		do
			create id.new_id (uid)
			create user.new_user (user_name, id)

			users_list.force (user, id)
			sorted_users.force (user)
			sorted_user_ids.force (id)

			set_environment
		ensure
				counter_incremented: ccounter = old ccounter + 1
		end

	add_group(gid: INTEGER_64 ; group_name: STRING)
		require
			postive_id : gid > 0
			id_not_used : not gid_exists(gid)
			name_valid : name_valid(group_name)
		local
			id 		: ID
			group	: GROUP
		do
			create id.new_id (gid)
			create group.new_group (group_name, id)

			groups_list.force (group, id)
			sorted_groups.force (group)
			sorted_group_ids.force (id)

			set_environment
		ensure
				counter_incremented: ccounter = old ccounter + 1
		end

	register_user(uid: INTEGER_64 ; gid: INTEGER_64)
		require
			postive_uid : uid > 0
			postive_gid : gid > 0
			uid_not_used : uid_exists(uid)
			gid_not_used : gid_exists(gid)
			registration_valid : not group_sub_exists(uid,gid)
		local
			id1		: ID
			id2		: ID
			user		: USER
			group		: GROUP
		do
			create id1.new_id (uid)
			create id2.new_id (gid)

			user := users_list.item (id1)
			check attached user as u then
				group := groups_list.item (id2)
				check attached group as g then
					user.register_group_sub (group, id2)
					user.sorted_group_ids.force (id2)
					group.register_user_sub (user, id1)
				end
			end
			set_environment
		end

	send_message(uid: INTEGER_64; gid: INTEGER_64; txt: STRING)
		require
			postive_uid : uid > 0
			postive_gid : gid > 0
			message_valid : txt.at(1).is_alpha
			authorization: user_sub_exists(gid,uid)
		local
			id1		: ID
			id2		: ID
			user	: USER
			text	 : MESSAGE
		do
			create id1.new_id (uid)
			create id2.new_id (gid)

			mcounter := mcounter + 1
			create text.new_message (id1, id2, txt,mcounter)

			user := users_list.item (id1)
			check attached user as u then
				messages_list.add_message (text)
				message_all_users (text)
			end
			set_environment
		end

	read_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require
			postive_uid : uid > 0
			postive_mid : mid > 0
			uid_not_used : uid_exists(uid)
			mid_valid : message_id_valid(mid)
			authorization: not (message_status(uid,mid) ~ "unavailable")
			mid_unvailable: not deleted_message(uid, mid)
		local
			id1		: ID
			user	: USER
		do
			status.make_empty
			message.make_empty

			create id1.new_id (uid)
			user := users_list.item (id1)
			check attached user as u then
				if user.message_at (mid).status ~ "unread" then
					user.message_at (mid).read_message
					message.append (print_read_message(user, user.message_at (mid)))
				end
			end

			ccounter := ccounter + 1
			status 	:= "OK"
			message.append (print_combined_message)

		end


	delete_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require
			postive_uid : uid > 0
			postive_mid : mid > 0
			uid_not_used : uid_exists(uid)
			mid_valid : message_id_valid(mid)
			authorization: not (message_status(uid,mid) ~ "unavailable")
		local
			id1		: ID
			user	: USER
		do
			create id1.new_id (uid)
			user := users_list.item (id1)
			check attached user as u then
				if user.message_at (mid).status ~ "read" then
					user.message_at (mid).unavailable_message
					user.message_at (mid).deleted
				end
			end
			set_environment
		end

	set_message_preview(n: INTEGER_64)
		require
			postive_n : n > 0
		do
			messages_list.set_preview_length (n)
			set_environment
		end

	list_new_messages(uid: INTEGER_64)
		require
			postive_uid : uid > 0
			uid_not_used : uid_exists(uid)
		local
			id1		: ID
			user	: USER
		do
			status.make_empty
			message.make_empty

			create id1.new_id (uid)

			user := users_list.item (id1)
			check attached user as u then
				if no_message_with (user,"unread") then
					message.append ("  There are no new messages for this user.%N")
				else
					message.append (print_new_messages (user))
				end
			end

			ccounter := ccounter + 1
			status 	:= "OK"
		end

	list_old_messages(uid: INTEGER_64)
		require
			postive_uid : uid > 0
			uid_not_used : uid_exists(uid)
		local
			id1		: ID
			user	: USER
		do
			status.make_empty
			message.make_empty

			create id1.new_id (uid)

			user := users_list.item (id1)
			check attached user as u then
				if no_message_with (user,"read") then
					message.append ("  There are no old messages for this user.%N")
				else
					message.append (print_old_messages (user))
				end
			end

			ccounter := ccounter + 1
			status 	:= "OK"
		end

	list_users
		local
			user 	: USER
		do
			status.make_empty
			message.make_empty

			if sorted_users.is_empty then
				message.make_from_string ("  There are no users registered in the system yet.%N")
			else
				from
					sorted_users.start
				until
					sorted_users.after
				loop
					user := sorted_users.item_for_iteration
					check attached user as u then
						message.append (user.print_users)
						message.append ("%N")
					end
					sorted_users.forth
				end
			end

			ccounter := ccounter + 1
			status 	:= "OK"
		end

	list_groups
	local
		group 	: GROUP
	do
		status.make_empty
		message.make_empty

		if sorted_users.is_empty then
			message.make_from_string ("  There are no groups registered in the system yet.%N")
		else
			from
				sorted_groups.start
			until
				sorted_groups.after
			loop
				group := sorted_groups.item_for_iteration
				check attached group as g then
					message.append (group.print_groups)
					message.append ("%N")
				end
				sorted_groups.forth
			end
		end

		ccounter := ccounter + 1
		status 	:= "OK"
	end

feature -- queries
	users_list 			: HASH_TABLE [USER, ID]
	sorted_users		: SORTED_TWO_WAY_LIST [USER]
	sorted_user_ids 	: SORTED_TWO_WAY_LIST [ID]

	groups_list 		: HASH_TABLE [GROUP, ID]
	sorted_groups		: SORTED_TWO_WAY_LIST [GROUP]
	sorted_group_ids 	: SORTED_TWO_WAY_LIST [ID]

	messages_list		: MESSAGE_LIST

	message				: STRING
	status				: STRING
	deb					: STRING
	ccounter			: INTEGER
	mcounter			: INTEGER


feature -- commands
	error_message(a_error: STRING)
		do
			status.make_empty
			status := ("ERROR ")

			message.make_empty
			message.append (a_error)
			message.append ("%N")

			ccounter := ccounter + 1
		ensure
			counter_incremented: ccounter = old ccounter + 1
		end

	message_user(a_user: USER; a_message : MESSAGE)
		local
			temp : MESSAGE
		do
			create temp.new_message (a_message.u_sender, a_message.g_reciever, a_message.message, a_message.message_id)

			a_user.increment_counter
			if a_message.u_sender.get_id = a_user.uid.get_id then
				temp.read_message
				a_user.message_list.force (temp,a_user.mcounter)
			elseif not (a_message.u_sender.get_id = a_user.uid.get_id) and a_user.group_sub_exists(a_message.g_reciever) then
				temp.unread_message
				a_user.message_list.force (temp,a_user.mcounter)
			else
				temp.unavailable_message
				a_user.message_list.force (temp,a_user.mcounter)
			end


		end

	message_all_users (a_message : MESSAGE)
		local
			user 	: USER
			j		: INTEGER
		do
			from
				j := 1
			until
				j > sorted_user_ids.count
			loop
				user := users_list.item (sorted_user_ids.at (j))
				check attached user as u then
					message_user (user, a_message)
				end

				j := j + 1
			end
		end

	set_environment
		do
			status.make_empty
			message.make_empty

			ccounter := ccounter + 1
			status 	:= "OK"
			message := print_combined_message
		end

feature --helper quries
	uid_exists (uid: INTEGER_64): BOOLEAN
		local
			id 		: ID
		do
			create id.new_id (uid)
			Result := users_list.has (id)
		end

	gid_exists (gid: INTEGER_64): BOOLEAN
		local
			id 		: ID
		do
			create id.new_id (gid)
			Result := groups_list.has (id)
		end

	user_sub_exists (gid: INTEGER_64; uid : INTEGER_64): BOOLEAN
		local
			id1 	: ID
			id2 	: ID
			group	: GROUP
			user	: USER
		do
			create id1.new_id (gid)
			create id2.new_id (uid)
			group := groups_list.item (id1)
			check attached group as g then
				user := users_list.item (id2)
				check attached user as u then
					Result := group.user_sub_exists (id2)
				end
			end
		end

	group_sub_exists (uid: INTEGER_64; gid : INTEGER_64): BOOLEAN
		local
			id1 	: ID
			id2 	: ID
			user	: USER
			group	: GROUP
		do
			create id1.new_id (uid)
			create id2.new_id (gid)
			user := users_list.item (id1)
			check attached user as u then
				group := groups_list.item (id2)
				check attached group as g then
					Result := user.group_sub_exists (id2)
				end
			end
		end

	message_id_valid(a_mid : INTEGER_64) : BOOLEAN
		do
			Result := messages_list.message_ids.has (a_mid)
		end

	name_valid (a_name : STRING): BOOLEAN
		do
			Result := a_name.count > 0 and then a_name.at (1).is_alpha
		end

	message_status(uid: INTEGER_64; mid: INTEGER_64): STRING
		local
			id1	: ID
			user	: USER
		do
			create Result.make_from_string ("")
			create id1.new_id (uid)
			user := users_list.item (id1)
			check attached user as u then
					Result := user.message_at (mid).status
			end
		end

	deleted_message (uid: INTEGER_64; mid: INTEGER_64): BOOLEAN
		local
			id1	: ID
			user	: USER
		do
			Result := false
			create id1.new_id (uid)
			user := users_list.item (id1)
			check attached user as u then
				if (user.message_at (mid).status ~ "unavailable") and user.message_at (mid).del_flag then
					Result := true
				end
			end
		end

	no_message_with (a_user: USER; state : STRING) : BOOLEAN
		local
			j		: INTEGER
		do
			Result := true
			from
				j := 1
			until
				j > a_user.mcounter
			loop
				if  a_user.message_list.at (j).status ~ state then
					Result := false
				else
					--nothing
				end
			j := j + 1
			end
		end

feature -- printing

	print_users : STRING
		local
			user : USER
		do
			create Result.make_from_string ("  Users:")
			Result.append ("%N")

			from
			 	sorted_user_ids.start
			until
				sorted_user_ids.after
			loop
				user := users_list.item (sorted_user_ids.item_for_iteration)
				check attached user as u then
					user.set_id (sorted_user_ids.item_for_iteration)
					Result.append("    ")
					Result.append (user.print_users)
					Result.append ("%N")
				end
				sorted_user_ids.forth
			end
		end

	print_groups : STRING
		local
			group	 : GROUP
		do
			create Result.make_from_string ("  Groups:")
			Result.append ("%N")

			from
			 	sorted_group_ids.start
			until
				sorted_group_ids.after
			loop
				group := groups_list.item (sorted_group_ids.item_for_iteration)
				check attached group as g then
					group.set_id (sorted_group_ids.item_for_iteration)
					Result.append("    ")
					Result.append (group.print_groups)
					Result.append ("%N")
				end
				sorted_group_ids.forth
			end
		end

	print_registrations : STRING
		local
			user : USER
		do
			create Result.make_from_string ("  Registrations:")
			Result.append ("%N")

			from
			 	sorted_user_ids.start
			until
				sorted_user_ids.after
			loop
				user := users_list.item (sorted_user_ids.item_for_iteration)
				check attached user as u then
					user.set_id (sorted_user_ids.item_for_iteration)
					Result.append (user.print_subs)
				end
				sorted_user_ids.forth
			end
		end


	print_messages : STRING
		do
			create Result.make_from_string ("  All messages:")
			Result.append ("%N")
			Result.append(messages_list.out)
		end


	print_message_status : STRING
		local
			user 	: USER
			j		: INTEGER
		do
			create Result.make_from_string ("  Message state:")
			Result.append ("%N")

			from
				j := 1
			until
				j > mcounter
			loop
				from
				 	sorted_user_ids.start
				until
					sorted_user_ids.after
				loop
					user := users_list.item (sorted_user_ids.item_for_iteration)
					check attached user as u then
						user.set_id (sorted_user_ids.item_for_iteration)
						Result.append (user.print_message_at (j))
					end
					sorted_user_ids.forth
				end
			j := j + 1
			end
		end

	print_read_message (a_user: USER ;a_message : MESSAGE)  : STRING
		do
			create Result.make_from_string ("  Message for user ")
			Result.append (a_user.print_user_and_id)
			Result.append(": ")
			Result.append (a_message.print_message_with_id)
			Result.append ("%N")

		end

	print_new_messages (a_user: USER) : STRING
		local
			j		: INTEGER
			count	: INTEGER
		do
			create Result.make_from_string (" ")
			count := 1

			if a_user.mcounter > 0 then
				Result.append (" New/unread messages for user ")
				Result.append(a_user.print_user_and_id)
				Result.append(":")
				Result.append ("%N")

				from
					j := 1
				until
					j > a_user.mcounter
				loop
					if a_user.message_list.at (j).status ~ "unread" then
						Result.append (messages_list.print_message_at(a_user.message_list.at (j).message_id))
					elseif  a_user.message_list.at (j).status ~ "unavailable" then
						count := count + 1
					end
				j := j + 1
				end

				if count = a_user.mcounter then
					Result.make_empty
					Result.append ("  There are no new messages for this user.%N")
				end
			end
		end

	print_old_messages (a_user: USER) : STRING
		local
			j		: INTEGER
			count	: INTEGER
		do
			create Result.make_from_string (" ")
			count := 1

			if a_user.mcounter > 0 then
				Result.append (" Old/read messages for user ")
				Result.append(a_user.print_user_and_id)
				Result.append(":")
				Result.append ("%N")

				from
					j := 1
				until
					j > a_user.mcounter
				loop
					if a_user.message_list.at (j).status ~ "read" then
						Result.append (messages_list.print_message_at(a_user.message_list.at (j).message_id))
					elseif  a_user.message_list.at (j).status ~ "unavailable" then
						count := count + 1
					else
						--nothing
					end
				j := j + 1
				end
			end
		end


	print_combined_message : STRING
		do
			create Result.make_from_string ("")
			Result.append (print_users)
			Result.append (print_groups)
			Result.append (print_registrations)
			Result.append (print_messages)
			Result.append (print_message_status)
		end

	out : STRING
		do
			create Result.make_from_string ("  ")
			Result.append (ccounter.out)
			Result.append (":  ")
			Result.append (status)
			Result.append ("%N")
			Result.append (message)
		end



------------------------------------------------
feature -- queries
	s 					: STRING
	i 					: INTEGER

feature
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end
end




