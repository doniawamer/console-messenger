note
	description: "Event Driven Publish and Subscribe"
	author: ""
	date: "$Date$"
	revision: "$Revision$"


class ETF_EVENT [G -> TUPLE]

inherit
	ANY
		redefine
			default_create
		end

create
	default_create
 feature {NONE}
	default_create
		do
			create {ARRAYED_LIST [PROCEDURE [ANY, G]]} actions.make (2)
		end

 	actions: LIST [PROCEDURE [ANY, G]]

feature
	has(an_action: PROCEDURE [ANY, G]): BOOLEAN
		do
			Result :=  actions.has (an_action)
		end

	attach (an_action: PROCEDURE [ANY, G])
			-- Add an_action to the list to be notified.
		require
			an_action_not_void: an_action /= void
			an_action_not_already_attached: not has (an_action)
		do
			actions.extend (an_action)
		ensure
			an_action_attached: actions.count = old actions.count + 1 and actions.has (an_action)
		end

	notify (args: G)
			-- Notify (invoke) all actions in list attached to an event.

		do
			actions.do_all (agent execute (?, args))
		end

	execute (P: PROCEDURE [ANY, G]; args: G)
		do
			p.call(args)
		end


end


