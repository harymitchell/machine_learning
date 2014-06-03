note
	description: "Summary description for {GAME_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_STATE

create
	make

feature {NONE} -- Init

	make
			-- Initliaze Current
		do
			create white_team
			create black_team
			create checker_board.make_checker_board
			create checkers_off_the_table.make (0)
			create checkers_on_the_table.make (0)
			create checkers_threatened_by_black.make (0)
			create checkers_threatened_by_white.make (0)
			create move_generator.make_with_game_state (Current)
			initialize
		end

	initialize
			-- Initiliaze Current.
		do
			initialize_checkers_on_the_table
		end

	initialize_checkers_on_the_table
			-- Initialize `checkers_on_the_table'.
		do
			across 1|..| 8 as ic_rows loop
				across 1|..| 4 as ic_columns  loop
					if attached checker_board.item (ic_rows.item, ic_columns.item).current_checker as al_checker then
						checkers_on_the_table.extend (al_checker)
					end
				end
			end
		end

feature -- Access

	checker_board: CHECKER_BOARD
			-- Board for Current game.

	white_team: CHECKER_PLAYER

	black_team: CHECKER_PLAYER

	checkers_on_the_table: ARRAYED_LIST [CHECKER]

	checkers_off_the_table: ARRAYED_LIST [CHECKER]

	checkers_threatened_by_black: ARRAYED_LIST [CHECKER]

	checkers_threatened_by_white: ARRAYED_LIST [CHECKER]

feature -- Basic Operations

	human_against_human_game_loop
		do
			if is_game_over then
				terminate_game
			end
		end

	human_against_computer_game_loop (a_computer_is_white: BOOLEAN)
		do
			if is_game_over then
				terminate_game
			elseif is_computer_turn then
				is_computer_turn := False
				move_generator.generate_move (a_computer_is_white)
				human_against_computer_game_loop (a_computer_is_white)
			else
			end
		end

	computer_against_computer_game_loop
		do
			if is_game_over then
				terminate_game
			elseif is_white_turn then
				is_white_turn := False
				move_generator.generate_move (True)
				computer_against_computer_game_loop
			else
				is_white_turn := True
				move_generator.generate_move (False)
				computer_against_computer_game_loop
			end
		end

	move_checker (a_from_container, a_to_container: CHECKER_CONTAINER)
			-- Moves {CHECKER} from `a_from_container' to `a_to_container'.
		require
			valid_from_row: checker_board.is_valid_row (a_from_container.row_index)
			valid_from_column: checker_board.is_valid_column (a_from_container.column_index)
			valid_to_row: checker_board.is_valid_row (a_to_container.row_index)
			valid_to_column: checker_board.is_valid_column (a_to_container.column_index)
			has_from_checker: attached a_from_container.current_checker
			not_has_to_checker: not attached a_to_container.current_checker
		local
			l_checker: CHECKER
			l_jumped_checker: detachable CHECKER
			l_to_row, l_to_column, l_from_row, l_from_column: INTEGER
		do
			l_to_row := a_to_container.row_index
			l_from_row := a_from_container.row_index
			l_to_column := a_to_container.column_index
			l_from_column := a_from_container.column_index

			l_checker := a_from_container.attached_current_checker
			a_from_container.deactivate_current_checker
			a_to_container.extend (l_checker)

			if l_from_row < l_to_row and then l_to_row - l_from_row = 1 then
				-- Moving up, no jumps.
			elseif l_from_row < l_to_row and then l_to_row - l_from_row = 2 then
				-- Moving up, with a jump.
				execute_jump (a_to_container, a_from_container, False)
			elseif l_from_row > l_to_row and then l_to_row -  l_from_row = -1 then
				-- Moving down, no jumps.
			elseif l_from_row > l_to_row and then l_to_row -  l_from_row = -2 then
				-- Moving down, with a jump
				execute_jump (a_to_container, a_from_container, True)
			end

			if can_double_jump then
--				move_checker (l_to_row, l_to_column, )
			else
				--Move actions
--				update_game_state
			end
		end

feature -- Status: Game Stats

	is_white_turn: BOOLEAN

	is_computer_turn: BOOLEAN

	is_game_over: BOOLEAN
		do
			Result := is_game_aborted or else (across checkers_on_the_table as ic_checkers some ic_checkers.item.is_white end and then
												across checkers_on_the_table as ic_checkers some ic_checkers.item.is_black end)
		end

	is_game_aborted: BOOLEAN

	winner: detachable CHECKER_PLAYER
		do
			if is_game_over then
				if white_team_won then
					Result := white_team
				else
					Result := black_team
				end
			end
		end

	white_team_won: BOOLEAN
		local
			l_count: INTEGER
		do
			across checkers_on_the_table as ic_checker loop
				if ic_checker.item.is_white and then ic_checker.item.is_active then
					l_count := l_count + 1
				end
			end
			Result := l_count > (checkers_on_the_table.count/2)
		end

feature -- Status: Game Play Stats

	can_double_jump: BOOLEAN = False

	is_even_row (a_row: INTEGER): BOOLEAN
			--Is this row odd?
		do
			Result := a_row \\ 2 = 0
		end

	are_checkers_of_different_color (a_checker, a_other_checker: CHECKER): BOOLEAN
			-- Are these two checkers from different sides/ colors?
		do
			Result := not (a_checker.is_white and then a_other_checker.is_white) and then not (a_checker.is_black and then a_other_checker.is_black)
		end

feature -- Implementation

	move_generator: CHECKER_MOVE_GENERATOR

	execute_jump (a_to_container, a_from_container: CHECKER_CONTAINER; a_is_moving_up: BOOLEAN)
			-- Executes the jumping of a piece from `a_from_container' to `a_to_container', handling the discarding of jumped piece.
		local
			l_jumped_container: detachable CHECKER_CONTAINER
			l_jumped_container_row, l_jumped_container_column: INTEGER
			l_jumped_checker: CHECKER
		do
			if a_is_moving_up and then a_to_container.column_index < a_from_container.column_index then -- "Moving up and to the left."
				l_jumped_container_row := a_to_container.row_index + 1
				if is_even_row (a_from_container.row_index) then
					l_jumped_container_column := a_from_container.column_index - 1
				else
					l_jumped_container_column := a_from_container.column_index
				end
			elseif a_is_moving_up and then a_to_container.column_index > a_from_container.column_index then -- "Moving up, and to the right."
				l_jumped_container_row := a_to_container.row_index + 1
				if is_even_row (a_from_container.row_index) then
					l_jumped_container_column := a_from_container.column_index
				else
					l_jumped_container_column := a_from_container.column_index + 1
				end
			elseif not a_is_moving_up and then a_to_container.column_index < a_from_container.column_index then -- "Moving down, and to the left."
				l_jumped_container_row := a_to_container.row_index - 1
				if is_even_row (a_from_container.row_index) then
					l_jumped_container_column := a_from_container.column_index - 1
				else
					l_jumped_container_column := a_from_container.column_index
				end
			elseif not a_is_moving_up and then a_to_container.column_index > a_from_container.column_index then -- "Moving down, and to the right."
				l_jumped_container_row := a_to_container.row_index - 1
				if is_even_row (a_from_container.row_index) then
					l_jumped_container_column := a_from_container.column_index
				else
					l_jumped_container_column := a_from_container.column_index + 1
				end
			end
			-- Determine if a container was actually jumped.
			if l_jumped_container_row > 0 and then l_jumped_container_column > 0 then
				l_jumped_container := checker_board.item (l_jumped_container_row, l_jumped_container_column)
			end
			-- Remove that checker from the board.
			if attached l_jumped_container as al_container and then attached al_container.current_checker as al_checker and then are_checkers_of_different_color (al_checker, a_to_container.attached_current_checker) then
				l_jumped_checker := al_checker
				checkers_off_the_table.extend (l_jumped_checker)
				checkers_on_the_table.prune (l_jumped_checker)
				al_container.deactivate_current_checker
			end
		end

	terminate_game
			-- Determines the winner of the game.
		do

		end

end
