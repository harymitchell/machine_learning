note
	description: "Model class representing one checker piece."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECKER

create
	make_with_color

feature {NONE} -- Init

	make_with_color (a_color: IMMUTABLE_STRING_32)
			-- Init Current with a color.
		require
			valid_color : a_color.same_string_general (white_color_constant) or else a_color.same_string_general (black_color_constant)
		do
			color := a_color
			initialize
		end

	initialize
			-- initialize Current.
		do
		end

feature -- Access

	color: IMMUTABLE_STRING_32
			-- Color of Current.

	container: detachable CHECKER_CONTAINER
			-- Container for Current.

feature -- Status Report

	is_active: BOOLEAN
			-- Is Current active?

	is_white: BOOLEAN
			-- Is Current a white checker?
		do
			Result := color.same_string_general (white_color_constant)
		end

	is_black: BOOLEAN
			-- Is Current blank?
		do
			Result := not is_white
		end

	is_king: BOOLEAN
			-- Is Current a King?

feature -- Settings

	set_is_king (a_is_king: BOOLEAN)
			-- Set `is_king'.
		do
			is_king := a_is_king
		ensure
			is_king_set: is_king = a_is_king
		end

	activate_with_container (a_container: CHECKER_CONTAINER)
			-- Activates Current and sets `container' to `a_container'.
		do
			is_Active := True
			container := a_container
		end

	deactivate
			-- Set `is_active' to False and `container' to Void.
		do
			is_active := False
			container := Void
		end

feature -- Implementation: Constants

	white_color_constant: IMMUTABLE_STRING_32
			-- Constant for white.
		do
			Result := "white"
		end

	black_color_constant: IMMUTABLE_STRING_32
			-- Constant for black.
		do
			Result := "black"
		end

invariant

	active_implies_container: is_active implies attached container
	not_active_implies_no_container: not is_active implies not attached container

end
