note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_USER_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_user(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as uid and then attached {STRING} etf_cmd_args[2] as user_name
			then
				out := "add_user(" + etf_event_argument_out("add_user", "uid", uid) + "," + etf_event_argument_out("add_user", "user_name", user_name) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_user_precond(uid: INTEGER_64 ; user_name: STRING): BOOLEAN
		do  
			Result := 
				         comment ("UID = INTEGER_64")
				and then comment ("USER = STRING")
		ensure then  
			Result = 
				         comment ("UID = INTEGER_64")
				and then comment ("USER = STRING")
		end 
feature -- command 
	add_user(uid: INTEGER_64 ; user_name: STRING)
		require 
			add_user_precond(uid, user_name)
    	deferred
    	end
end
