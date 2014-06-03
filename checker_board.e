note
	description: "[
			Represents the data structure of a Checker Board
			A Matrix of Containers which can contain a Checker piece.
			The structure has 8 rows an 4 columns.  Only black square are included,
			since that are the only valid squares for game play.

			* Visually, the first black square starts in the bottom left, and
			  the last is in the top right.  See Diagram, where W is white piece,
			  E is empty, and B is black.  A hyphen (-) represents a piece that is not modeled.

			  A checker board at initialization looks like this:

			  -	 W	-	W	-	W	-	W
			  W	 -	W	-	W	-	W	-
			  -	 W	-	W	-	W	-	W
			  E	 -	E	-	E	-	E	-
			  -	 E	-	E	-	E	-	E
			  B	 -	B	-	B	-	B	-
			  -	 B	-	B	-	B	-	B
			  B	 -	B	-	B	-	B	-

			Even Row: Valid moves for piece P, where V is valid regular, J is valid jump, and N is non valid:

			n J n J n
			n V V n n
			n n P n n
			n V V n n
			n J n J n

			Odd Row: Valid moves for piece P, where V is valid regular, J is valid jump, and N is non valid:

			n J n J n
			n n V V n
			n n P n n
			n n V V n
			n J n J n

			Our board at init looks like:

			  W W W W
			  W W W W
			  W W W W
			  E E E E
			  E E E E
			  B B B B
			  B B B B
			  B B B B

]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CHECKER_BOARD

inherit
	MATRIX [CHECKER_CONTAINER]

create
	make_checker_board

feature {NONE} -- Init

	make_checker_board
			-- Create Current.
		do
			make (8, 4)
			initialize_board
		end

	initialize_board
            -- Initialize Current.
        local
        	l_white_checker: CHECKER
        	l_black_checker: CHECKER
        	l_temp_container: CHECKER_CONTAINER
            l_i, l_j: INTEGER_32
        do
        	create l_white_checker.make_with_color ("white")
        	create l_black_checker.make_with_color ("black")

			-- Initialize Checker Board.
        	from
        		l_i := 1
        	until
        		l_i > 8
        	loop
        		from
        			l_j := 1
        		until
        			l_j > 4
        		loop
        			create l_temp_container
					if l_i < 4 then -- Is black side.
						l_temp_container.extend (l_black_checker.twin)
					elseif l_i > 5 then -- Is white side.
						l_temp_container.extend (l_white_checker.twin)
					end
					l_temp_container.set_row_index (l_i)
					l_temp_container.set_column_index (l_j)
        			extend (l_temp_container, l_i)
        			l_j := l_j + 1
        		end
        		l_i := l_i + 1
        	end
        end

feature -- Access

--	board: s

end
