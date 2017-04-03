note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_REGISTER_USER_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent register_user(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as uid and then attached {INTEGER_64} etf_cmd_args[2] as gid
			then
				out := "register_user(" + etf_event_argument_out("register_user", "uid", uid) + "," + etf_event_argument_out("register_user", "gid", gid) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	register_user_precond(uid: INTEGER_64 ; gid: INTEGER_64): BOOLEAN
		do  
			Result := 
				         comment ("UID = INTEGER_64")
				and then comment ("GID = INTEGER_64")
		ensure then  
			Result = 
				         comment ("UID = INTEGER_64")
				and then comment ("GID = INTEGER_64")
		end 
feature -- command 
	register_user(uid: INTEGER_64 ; gid: INTEGER_64)
		require 
			register_user_precond(uid, gid)
    	deferred
    	end
end
