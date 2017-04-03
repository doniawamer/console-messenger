note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_SET_MESSAGE_PREVIEW
inherit
	ETF_SET_MESSAGE_PREVIEW_INTERFACE
		redefine set_message_preview end
create
	make

feature -- queries
	error : BOOLEAN


feature -- command
	set_message_preview(n: INTEGER_64)
    	do
    		err_n_negative(n)

    		if not error then
    			model.set_message_preview (n)
    		end
			etf_cmd_container.on_change.notify ([Current])
    	end

feature -- error gen

		err_n_negative(a_n: INTEGER_64)
		do
			if 	a_n <= 0 and not error then
				model.error_message ("  Message length must be greater than zero.")
				error := true
			end
		end

end
