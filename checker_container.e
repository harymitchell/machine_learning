note
	description: "Summary description for {CHECKER_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECKER_CONTAINER

feature -- Init

feature --Access

	current_checker: detachable CHECKER

	attached_current_checker: CHECKER
		do
			check attached current_checker as al_checker then
				Result := al_checker
			end
		end

	row_index,
	column_index: INTEGER

feature -- Basic Operations

	extend (a_checker: CHECKER)
		require
			not_has_checker: not attached current_checker
		do
			current_checker := a_checker
			attached_current_checker.activate_with_container (Current)
		end

	deactivate_current_checker
			-- Set`checker.is_active' to False and remove its container reference, purge Current.
		do
			attached_current_checker.deactivate
			purge
		end

feature -- Settings

	set_column_index (a_index: INTEGER)
		do
			column_index := a_index
		end

	set_row_index (a_index: INTEGER)
		do
			row_index := a_index
		end

feature {NONE} -- Implementation

	purge
		require
			has_checker: attached current_checker
		do
			current_checker := Void
		end

feature {NONE} -- Status report: Contract Support


invariant
	checker_is_active_and_reflects_current: attached current_checker implies attached_current_checker.is_active and then attached_current_checker.container = Current

end
