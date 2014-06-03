note
	description: "Summary description for {DECISION_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECISION_TREE
inherit
	ML_FORMULA

feature -- Access: Training Set

	results: ARRAYED_LIST [BOOLEAN]
			-- Results of Current training data.
		attribute
			create Result.make (0)
		end

	attributes: ARRAYED_LIST [DECISION_TREE_ATTRIBUTE [ANY]]
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

	entropy_for_set: REAL_64
			-- Entropy for Current.
		do
			Result := entropy_of (positive_outcome_count, negative_outcome_count)
		end

end
