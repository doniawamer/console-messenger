note
	description: "Singleton access to the default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MESSENGER_ACCESS

feature
	m: MESSENGER
		once
			create Result.make
		end

invariant
	m = m
end




