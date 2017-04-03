note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_LIST_GROUPS
inherit
	ETF_LIST_GROUPS_INTERFACE
		redefine list_groups end
create
	make
feature -- command
	list_groups
    	do
			model.list_groups
			etf_cmd_container.on_change.notify ([Current])
    	end

end
