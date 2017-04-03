note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_ADD_GROUP_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent add_group(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER_64} etf_cmd_args[1] as gid and then attached {STRING} etf_cmd_args[2] as group_name
			then
				out := "add_group(" + etf_event_argument_out("add_group", "gid", gid) + "," + etf_event_argument_out("add_group", "group_name", group_name) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	add_group_precond(gid: INTEGER_64 ; group_name: STRING): BOOLEAN
		do  
			Result := 
				         comment ("GID = INTEGER_64")
				and then comment ("GROUP = STRING")
		ensure then  
			Result = 
				         comment ("GID = INTEGER_64")
				and then comment ("GROUP = STRING")
		end 
feature -- command 
	add_group(gid: INTEGER_64 ; group_name: STRING)
		require 
			add_group_precond(gid, group_name)
    	deferred
    	end
end
