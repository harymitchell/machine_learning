note
	description: "Summary description for {DECISION_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECISION_TREE

inherit
	ML_FORMULA

create
	default_create,
	make_with_csv_file_path

feature -- Init

	make_with_csv_file_path (a_file_path: STRING_32)
		do
			parse_data_file (a_file_path)
		end

feature -- Access: Training Set

	results: ARRAYED_LIST [BOOLEAN]
			-- Results of Current training data synthesized to {BOOLEAN.
		attribute
			create Result.make (0)
		end

	raw_results: ARRAYED_LIST [ANY]
			-- Raw results of Current training data.
		attribute
			create Result.make (0)
		end

	attributes: ARRAYED_LIST [DECISION_TREE_ATTRIBUTE [READABLE_STRING_GENERAL]]
			-- Attributes for Current system.
		attribute
			create Result.make (0)
		end

	positive_outcome_count: INTEGER
			-- Count of `results' with a positive outcome.
		do
			across results as ic_results loop
				if ic_results.item then
					Result := Result + 1
				end
			end
		end

	negative_outcome_count: INTEGER
			-- Count of `results' with a negative outcome.
		do
			Result := results.count - positive_outcome_count
		end

	entropy_for_set: REAL_32
			-- Entropy for Current.
		do
			Result := entropy_of (positive_outcome_count, negative_outcome_count)
		end

feature -- Imp

	parse_data_file (a_path_string: STRING_32)
		local
			l_file: PLAIN_TEXT_FILE
			l_text: STRING_32
			l_lines, l_data_points: LIST [STRING_32]
			l_attribute: DECISION_TREE_ATTRIBUTE [READABLE_STRING_GENERAL]
			l_data_point_count, l_attribute_count: INTEGER
		do
			-- Get text.
			create l_file.make_open_read (a_path_string)
			l_file.read_stream (l_file.count)
			l_text := l_file.last_string
			l_file.close

			-- Parse text.
			l_lines := l_text.split ('%N')

			l_data_point_count := l_lines.at (1).split (' ').count
			l_attribute_count := l_data_point_count - 1

			across 1|..| l_attribute_count as ic_index loop
				create l_attribute.make ("attribute" + " " + ic_index.item.out, <<>>, Current)
				attributes.extend (l_attribute)
			end

			across l_lines as ic_lines loop
				l_data_points := ic_lines.item.split (' ')
				if l_data_points.count = l_data_point_count then
					across 1|..| l_data_point_count as ic_index loop
						if ic_index.item = l_data_point_count then
							raw_results.extend (l_data_points.at (ic_index.item))
						else
							attributes.at (ic_index.item).extend_to_training_data (l_data_points.at (ic_index.item))
						end
					end
				end
			end
		end

end
