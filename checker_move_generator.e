note
	description: "Summary description for {CHECKER_MOVE_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECKER_MOVE_GENERATOR

create
	make_with_game_state

feature -- Init

	make_with_game_state (a_game_state: GAME_STATE)
		do
			game_state := a_game_state
		end

feature -- Basic operations

	generate_move (a_is_white: BOOLEAN)
			-- Generates and executes the "best" valid move for white if `a_is_white' (otherwise for black).
		do

		end

feature -- Implementation

	game_state: GAME_STATE

end
