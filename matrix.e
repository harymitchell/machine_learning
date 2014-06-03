note
	description: "Summary description for {MATRIX}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MATRIX[G-> ANY]

create
	make

feature {NONE}

	make (r, c: INTEGER)
			-- Make a matrix with `r' rows and `c' columns
		local
			i: INTEGER
			one_row: ARRAYED_LIST[G]
                        default_value: G
		do
			rows := r
			columns := c
            create matrix.make (c)
			from i:=1 until i > r loop
				create one_row.make (c)
                 matrix.extend (one_row)
				i := i + 1
			end
		ensure
			rows = matrix.count
			rows > 0 implies columns = matrix[1].capacity
		end

feature -- Access

	item alias "[]" ( i, j: INTEGER ): G
			-- The element at row `i' and column `j'.
		require
			is_valid_row    ( i )
			is_valid_column ( j )
		do
			Result := matrix.at (i).at (j)
		end

feature -- Basic opertions

	put ( el: G; i,j: INTEGER )
			-- Put element `el' at row `i' and column `j'.
		require
			is_valid_row    ( i )
			is_valid_column ( j )
		do
			matrix.at (i).at (j) := el
		ensure
			Current[i,j]= el
		end

feature -- Staus Reports

	is_valid_row ( i: INTEGER ): BOOLEAN
		do
			Result := 1 <= i and then  i <= rows
		end

	is_valid_column ( j: INTEGER ): BOOLEAN
		do
			Result := 1 <= j and then j <= columns
		end

feature {NONE}

	rows: INTEGER

	columns: INTEGER

	extend ( el: G; i: INTEGER )
		require
			is_valid_row    ( i )
			count_of (i) <= columns
		do
			matrix.at (i).extend (el)
		ensure
			count_of (i) <= columns
		end

	count_of (i: INTEGER): INTEGER
			-- Count of `Matrix' at index `i'.
		do
			Result := matrix [i].count
		end

feature {NONE} -- implementation

	matrix: ARRAYED_LIST[ARRAYED_LIST[G]]

end

