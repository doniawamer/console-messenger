note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_SET_MESSAGE_PREVIEW_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent set_message_preview(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as n
			then
				out := "set_message_preview(" + etf_event_argument_out("set_message_preview", "n", n) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command 
	set_message_preview(n: INTEGER_64)
    	deferred
    	end
end
