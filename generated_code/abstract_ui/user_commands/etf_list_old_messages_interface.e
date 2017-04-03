note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_LIST_OLD_MESSAGES_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent list_old_messages(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as uid
			then
				out := "list_old_messages(" + etf_event_argument_out("list_old_messages", "uid", uid) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	list_old_messages_precond(uid: INTEGER_64): BOOLEAN
		do  
			Result := 
				comment ("UID = INTEGER_64")
		ensure then  
			Result = 
				comment ("UID = INTEGER_64")
		end 
feature -- command 
	list_old_messages(uid: INTEGER_64)
		require 
			list_old_messages_precond(uid)
    	deferred
    	end
end
