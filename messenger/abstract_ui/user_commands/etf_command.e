note
	description: "The interface for an input COMMAND"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_COMMAND

inherit
	ETF_COMMAND_INTERFACE
		redefine
			make
		end

feature {NONE}
	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		local
		  model_access: MESSENGER_ACCESS
		do
			Precursor(an_etf_cmd_name, etf_cmd_args, an_etf_cmd_container)
			model := model_access.m
		end

feature -- Attributes
	model : MESSENGER
end
