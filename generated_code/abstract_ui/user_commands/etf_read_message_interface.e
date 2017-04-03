note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_READ_MESSAGE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent read_message(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as uid and then attached {INTEGER_64} etf_cmd_args[2] as mid
			then
				out := "read_message(" + etf_event_argument_out("read_message", "uid", uid) + "," + etf_event_argument_out("read_message", "mid", mid) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	read_message_precond(uid: INTEGER_64 ; mid: INTEGER_64): BOOLEAN
		do  
			Result := 
				         comment ("UID = INTEGER_64")
				and then comment ("MID = INTEGER_64")
		ensure then  
			Result = 
				         comment ("UID = INTEGER_64")
				and then comment ("MID = INTEGER_64")
		end 
feature -- command 
	read_message(uid: INTEGER_64 ; mid: INTEGER_64)
		require 
			read_message_precond(uid, mid)
    	deferred
    	end
end
