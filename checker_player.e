note
	description: "Summary description for {CHECKER_PLAYER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECKER_PLAYER

feature  -- Status

	is_computer: BOOLEAN

feature -- Settings

	set_is_computer (a_is_computer: BOOLEAN)
		do
			is_computer := a_is_computer
		end

end
