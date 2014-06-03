note
	description: "[
		CHECKER_BOARD_GRID is a GUI representation of a CHECKER_BOARD.
		* See Description for CHECKER_BOARD.
]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECKER_BOARD_GRID

inherit
	EV_STOCK_COLORS
	EV_SHARED_APPLICATION

create
	make_with_game_state

feature -- init

	make_with_game_state (a_game_state: GAME_STATE)
			-- Create Current with `a_checker_board'.
		do
			game_state := a_game_state
			create_interface_objects
		end

	create_interface_objects
			-- Common Creation.
		do
			create grid
			create widget
			initialize_grid
		end

	initialize_grid
			-- Initialize Current.
		do
			grid.set_row_count_to (8)
			grid.set_column_count_to (8)
			grid.enable_row_separators
			grid.enable_column_separators
			grid.set_row_height (checker_height)
			grid.set_minimum_width (grid_width)
			grid.header.hide
			update_grid_for_checker_board
		end

feature -- Access

	widget: EV_HORIZONTAL_BOX

	checker_height: INTEGER
		do
			Result := white_checker.height
		end

	checker_width: INTEGER
		do
			Result := white_checker.width
		end

	grid_width: INTEGER
		do
			Result := white_checker.width * 8
		end

feature -- Basic Operations

	update_grid_for_checker_board
			-- Updates `grid' for `checker_board'.
		local
			l_row, l_column: INTEGER_32
			l_grid_item : detachable EV_GRID_LABEl_ITEM
		do
			grid.clear
			-- Add containers to Checker Board.
        	from
        		l_row := 1
        	until
        		l_row > 8
        	loop
        		from
        			l_column := 1
        		until
        			l_column > 4
        		loop
					if attached checker_board.item (l_row, l_column).current_checker as al_checker then
						-- Determine Checker.
						if al_checker.is_black	then	-- Is black piece.
							l_grid_item := grid_item_with_checker (True, False)
						elseif al_checker.is_white then -- Is white piece.
							l_grid_item := grid_item_with_checker (False, False)
						else
							check current_checker_invalid: False end
						end
						check attached_checker_container: attached l_grid_item end
					else
						create l_grid_item
						l_grid_item.set_background_color (black)
					end
					check attached_checker_container: attached l_grid_item end
					l_grid_item.select_actions.extend (agent on_grid_item_select (l_grid_item))
					l_grid_item.set_data (checker_board.item (l_row, l_column))
					-- Determine position.
					if game_state.is_even_row (l_row) then
						grid.set_item ((l_column * 2) -1, l_row, l_grid_item)
					else
						grid.set_item (l_column * 2, l_row, l_grid_item)
					end
					-- Format grid item.
					l_grid_item.set_background_color (black)
					l_grid_item.column.set_width (checker_width + 3)
					-- Iterate
        			l_column := l_column + 1
        		end
        		l_row := l_row + 1
        	end

		end

feature -- Implementation

	game_state: GAME_STATE

	checker_board: CHECKER_BOARD
		attribute
			Result := game_state.checker_board
		end

	grid_item_with_checker (a_is_black: BOOLEAN; a_is_king: BOOLEAN): EV_GRID_LABEL_ITEM
			-- Returns a grid item with a checker pixel.
		do
			create Result

			-- Insert the Correct Checker Pixmap
			if a_is_black and then a_is_king then
				-- Make a black king
			elseif a_is_black then
				-- Make a black piece
				Result.set_pixmap (white_checker.twin)
			elseif a_is_king then
				-- Make a white king
			else
				-- Make a white piece
				Result.set_pixmap (black_checker.twin)
			end
--			if attached Result.pixmap as al_pixmap then
--				al_pixmap.pick_actions.extend (agent on_pixmap_pick)
--				al_pixmap.drop_actions.extend (agent on_pixmap_drop)
--				al_pixmap.set_pebble (Result)
--				al_pixmap.enable_pebble_positioning
----				al_pixmap.set_drag_and_drop_mode
--			end
		end

	white_checker: EV_PIXMAP
		attribute
			create Result
			Result.set_with_named_file ("/home/harrison/checkers/images/white_checker.jpg")
			Result.set_size ((Result.width/checker_size_constant).truncated_to_integer, (Result.height/checker_size_constant).truncated_to_integer)
		end

	black_checker: EV_PIXMAP
		attribute
			create Result
			Result.set_with_named_file ("/home/harrison/checkers/images/black_checker.jpg")
			Result.set_size ((Result.width/checker_size_constant).truncated_to_integer, (Result.height/checker_size_constant).truncated_to_integer)
		end

	checker_size_constant: REAL = 1.0

feature -- Event handling

	on_grid_item_select (a_item: EV_GRID_LABEL_ITEM)
		do
			if attached {CHECKER_CONTAINER} a_item.data as al_container and then attached al_container.current_checker then --and then attached {EV_GRID_LABEL_ITEM} a_item as al_item
				item_to_move := a_item
			elseif attached item_to_move as al_item and then attached {CHECKER_CONTAINER} al_item.data as al_from_container and then attached {CHECKER_CONTAINER} a_item.data as al_to_container  then
				game_state.move_checker (al_from_container, al_to_container)
				ev_application.add_idle_action_kamikaze (agent update_grid_for_checker_board)
			end
		end

	on_grid_item_press (a_x: INTEGER; a_y: INTEGER; a_button: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER)
		do
			ev_application.add_idle_action_kamikaze (agent on_item_select (a_x, a_y, a_screen_x, a_screen_y))
		end

	on_grid_item_release (a_x: INTEGER; a_y: INTEGER; a_button: INTEGER; a_x_tilt: DOUBLE; a_y_tilt: DOUBLE; a_pressure: DOUBLE; a_screen_x: INTEGER; a_screen_y: INTEGER)
		do
			ev_application.add_idle_action_kamikaze (agent on_item_deselect (a_x, a_y, a_screen_x, a_screen_y))
		end

	on_item_select (a_x, a_y, a_screen_x, a_screen_y: INTEGER)
		do
			do_nothing
		end

	on_item_deselect (a_x, a_y, a_screen_x, a_screen_y: INTEGER)
		do
			do_nothing
		end

feature -- Implementation: GUI

	grid: EV_GRID

	item_to_move: detachable EV_GRID_ITEM

end
