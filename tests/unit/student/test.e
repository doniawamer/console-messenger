note
	description: "Summary description for {TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
			add_boolean_case (agent t6)
		end

feature -- attribute
	access: MESSENGER_ACCESS

feature -- tests

	t1: BOOLEAN
		do
			comment ("t1: tests adding and existance of a user and counter incrementation%N ")
			access.m.reset

			access.m.add_user (1, "user 1")
			access.m.add_user (2, "user 2")
			access.m.add_user (3, "user 3")

			sub_comment(access.m.print_users)

			Result := access.m.users_list.count = 3
			check Result end
			Result := access.m.uid_exists (1) and access.m.uid_exists (2)
		end

	t2: BOOLEAN
		do
			comment ("t2: tests adding and existance of a group and counter incrementation%N")
			access.m.reset

			access.m.add_group (2, "group 2")
			access.m.add_group (1, "group 1")


			sub_comment(access.m.print_groups)

			Result := access.m.groups_list.count = 2

			check Result end
			Result := access.m.gid_exists (1) and access.m.gid_exists (2)
		end

	t3: BOOLEAN
		do
			comment ("t3: tests registering a user %N")
			access.m.reset

			access.m.add_user (1, "user 1")
			access.m.add_user (2, "user 2")

			access.m.add_group (2, "group 2")
			access.m.add_group (1, "group 1")

			access.m.register_user(1,1)
			access.m.register_user(2,2)

			sub_comment(access.m.print_registrations)

			Result := access.m.user_sub_exists (1, 1) and access.m.user_sub_exists (2, 2)

		end


		t4: BOOLEAN
			do
				comment ("t4: tests listing users and groups %N")
				access.m.reset

				access.m.add_user (1, "user 1")
				access.m.add_user (2, "user 2")

				access.m.add_group (2, "group 2")
				access.m.add_group (1, "group 1")

				sub_comment(access.m.print_users)
				sub_comment(access.m.print_groups)

				Result := (access.m.print_groups  ~   "  Groups:%N      1->group 1%N      2->group 2%N")
				check Result end
				Result := (access.m.print_users ~   "  Users:%N      1->user 1%N      2->user 2%N")

			end

		t5: BOOLEAN
			local
				id1		: ID
				id2		: ID
				user1	: USER
				user2	: USER
			do
				comment ("t5: tests sending, recieving, reading, deleting messages, and count and status changes %N")
				access.m.reset

				access.m.add_user (1, "user 1")
				access.m.add_user (2, "user 2")
				access.m.add_user (3, "user 3")

				access.m.add_group (2, "group 2")
				access.m.add_group (1, "group 1")

				access.m.register_user(1,1)
				access.m.register_user(2,2)
				access.m.register_user(3,1)

				access.m.send_message (1, 1, "message 1")
				create id1.new_id (1)
				create id2.new_id (3)

				sub_comment(access.m.print_messages)
				sub_comment(access.m.print_message_status)

				user1 := access.m.users_list.at (id1)
				check attached user1 as u then
					Result := user1.message_at (1).status ~ "read"
					check Result end
				end

				user2 := access.m.users_list.at (id2)
				check attached user2 as u then
					Result := user2.message_at (1).status ~ "unread"
					check Result end
				end

				access.m.read_message (3, 1)
				user2 := access.m.users_list.at (id2)
				check attached user2 as u then
					Result := user2.message_at (1).status ~ "read"
					check Result end
				end

				sub_comment("User 3 reads message")
				sub_comment(access.m.print_message_status)

				access.m.delete_message (3, 1)
				user2 := access.m.users_list.at (id2)
				check attached user2 as u then
					Result := user2.message_at (1).status ~ "unavailable"
					check Result end
				end

				sub_comment("User 3 deletes message")
				sub_comment(access.m.print_message_status)
			end

		t6: BOOLEAN
				local
					id1		: ID
					id2		: ID
					user1	: USER
					user2	: USER
				do
					comment ("t6: tests listing old, new messages, and preview length change %N")
					access.m.reset

					access.m.add_user (1, "user 1")
					access.m.add_user (2, "user 2")
					access.m.add_user (3, "user 3")

					access.m.add_group (2, "group 2")
					access.m.add_group (1, "group 1")

					access.m.register_user(1,1)
					access.m.register_user(2,2)
					access.m.register_user(3,1)

					access.m.send_message (1, 1, "message 1")
					create id1.new_id (1)
					create id2.new_id (3)

					sub_comment(access.m.print_messages)
					sub_comment(access.m.print_message_status)

					sub_comment("User 3 checks new messags")
					user2 := access.m.users_list.at (id2)
					check attached user2 as u then
						sub_comment("  New/unread messages for user [3, user 3]:")
						sub_comment("1->[sender: 1, group: 1, content: %"message 1%"] %N")

						sub_comment(user2.message_at (1).status.out)
						Result := user2.message_at (1).status ~ "unread"
						check Result end
					end

					sub_comment("User 1 checks old messags")
					user1 := access.m.users_list.at (id1)
					check attached user1 as u then
						sub_comment(access.m.print_old_messages (user1))
						sub_comment(access.m.print_new_messages (user1))
						Result := user1.message_at (1).status ~ "read"
						check Result end
					end

					sub_comment("Preview length changed to 2 %N")
					access.m.messages_list.set_preview_length (2)
					sub_comment(access.m.print_messages)
					Result := access.m.messages_list.preview_length.to_integer_32 = 2
				end
end
