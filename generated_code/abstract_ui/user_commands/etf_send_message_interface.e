note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_SEND_MESSAGE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent send_message(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as uid and then attached {INTEGER_64} etf_cmd_args[2] as gid and then attached {STRING} etf_cmd_args[3] as txt
			then
				out := "send_message(" + etf_event_argument_out("send_message", "uid", uid) + "," + etf_event_argument_out("send_message", "gid", gid) + "," + etf_event_argument_out("send_message", "txt", txt) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	send_message_precond(uid: INTEGER_64 ; gid: INTEGER_64 ; txt: STRING): BOOLEAN
		do  
			Result := 
				         comment ("UID = INTEGER_64")
				and then comment ("GID = INTEGER_64")
				and then comment ("TEXT = STRING")
		ensure then  
			Result = 
				         comment ("UID = INTEGER_64")
				and then comment ("GID = INTEGER_64")
				and then comment ("TEXT = STRING")
		end 
feature -- command 
	send_message(uid: INTEGER_64 ; gid: INTEGER_64 ; txt: STRING)
		require 
			send_message_precond(uid, gid, txt)
    	deferred
    	end
end
