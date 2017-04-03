class
 	 ETF_TYPE_CONSTRAINTS
feature -- list of enumeratd constants
	enum_items : HASH_TABLE[INTEGER, STRING]
		do
			create Result.make (10)
		end

	enum_items_inverse : HASH_TABLE[STRING, INTEGER_64]
		do
			create Result.make (10)
		end
feature -- query on declarations of event parameters
	evt_param_types_table : HASH_TABLE[HASH_TABLE[ETF_PARAM_TYPE, STRING], STRING]
		local
			add_user_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			add_group_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			register_user_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			send_message_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			read_message_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			delete_message_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			set_message_preview_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			list_new_messages_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			list_old_messages_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			list_groups_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
			list_users_param_types: HASH_TABLE[ETF_PARAM_TYPE, STRING]
		do
			create Result.make (10)
			Result.compare_objects
			create add_user_param_types.make (10)
			add_user_param_types.compare_objects
			add_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			add_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("USER", create {ETF_STR_PARAM}), "user_name")
			Result.extend (add_user_param_types, "add_user")
			create add_group_param_types.make (10)
			add_group_param_types.compare_objects
			add_group_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GID", create {ETF_INT_PARAM}), "gid")
			add_group_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GROUP", create {ETF_STR_PARAM}), "group_name")
			Result.extend (add_group_param_types, "add_group")
			create register_user_param_types.make (10)
			register_user_param_types.compare_objects
			register_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			register_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GID", create {ETF_INT_PARAM}), "gid")
			Result.extend (register_user_param_types, "register_user")
			create send_message_param_types.make (10)
			send_message_param_types.compare_objects
			send_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			send_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GID", create {ETF_INT_PARAM}), "gid")
			send_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("TEXT", create {ETF_STR_PARAM}), "txt")
			Result.extend (send_message_param_types, "send_message")
			create read_message_param_types.make (10)
			read_message_param_types.compare_objects
			read_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			read_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MID", create {ETF_INT_PARAM}), "mid")
			Result.extend (read_message_param_types, "read_message")
			create delete_message_param_types.make (10)
			delete_message_param_types.compare_objects
			delete_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			delete_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MID", create {ETF_INT_PARAM}), "mid")
			Result.extend (delete_message_param_types, "delete_message")
			create set_message_preview_param_types.make (10)
			set_message_preview_param_types.compare_objects
			set_message_preview_param_types.extend (create {ETF_INT_PARAM}, "n")
			Result.extend (set_message_preview_param_types, "set_message_preview")
			create list_new_messages_param_types.make (10)
			list_new_messages_param_types.compare_objects
			list_new_messages_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			Result.extend (list_new_messages_param_types, "list_new_messages")
			create list_old_messages_param_types.make (10)
			list_old_messages_param_types.compare_objects
			list_old_messages_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}), "uid")
			Result.extend (list_old_messages_param_types, "list_old_messages")
			create list_groups_param_types.make (10)
			list_groups_param_types.compare_objects
			Result.extend (list_groups_param_types, "list_groups")
			create list_users_param_types.make (10)
			list_users_param_types.compare_objects
			Result.extend (list_users_param_types, "list_users")
		end
feature -- query on declarations of event parameters
	evt_param_types_list : HASH_TABLE[LINKED_LIST[ETF_PARAM_TYPE], STRING]
		local
			add_user_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			add_group_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			register_user_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			send_message_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			read_message_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			delete_message_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			set_message_preview_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			list_new_messages_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			list_old_messages_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			list_groups_param_types: LINKED_LIST[ETF_PARAM_TYPE]
			list_users_param_types: LINKED_LIST[ETF_PARAM_TYPE]
		do
			create Result.make (10)
			Result.compare_objects
			create add_user_param_types.make
			add_user_param_types.compare_objects
			add_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			add_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("USER", create {ETF_STR_PARAM}))
			Result.extend (add_user_param_types, "add_user")
			create add_group_param_types.make
			add_group_param_types.compare_objects
			add_group_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GID", create {ETF_INT_PARAM}))
			add_group_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GROUP", create {ETF_STR_PARAM}))
			Result.extend (add_group_param_types, "add_group")
			create register_user_param_types.make
			register_user_param_types.compare_objects
			register_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			register_user_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GID", create {ETF_INT_PARAM}))
			Result.extend (register_user_param_types, "register_user")
			create send_message_param_types.make
			send_message_param_types.compare_objects
			send_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			send_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("GID", create {ETF_INT_PARAM}))
			send_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("TEXT", create {ETF_STR_PARAM}))
			Result.extend (send_message_param_types, "send_message")
			create read_message_param_types.make
			read_message_param_types.compare_objects
			read_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			read_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MID", create {ETF_INT_PARAM}))
			Result.extend (read_message_param_types, "read_message")
			create delete_message_param_types.make
			delete_message_param_types.compare_objects
			delete_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			delete_message_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("MID", create {ETF_INT_PARAM}))
			Result.extend (delete_message_param_types, "delete_message")
			create set_message_preview_param_types.make
			set_message_preview_param_types.compare_objects
			set_message_preview_param_types.extend (create {ETF_INT_PARAM})
			Result.extend (set_message_preview_param_types, "set_message_preview")
			create list_new_messages_param_types.make
			list_new_messages_param_types.compare_objects
			list_new_messages_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			Result.extend (list_new_messages_param_types, "list_new_messages")
			create list_old_messages_param_types.make
			list_old_messages_param_types.compare_objects
			list_old_messages_param_types.extend (create {ETF_NAMED_PARAM_TYPE}.make("UID", create {ETF_INT_PARAM}))
			Result.extend (list_old_messages_param_types, "list_old_messages")
			create list_groups_param_types.make
			list_groups_param_types.compare_objects
			Result.extend (list_groups_param_types, "list_groups")
			create list_users_param_types.make
			list_users_param_types.compare_objects
			Result.extend (list_users_param_types, "list_users")
		end
feature -- comments for contracts
	comment(etf_s: STRING): BOOLEAN
		do
			Result := TRUE
		end
end