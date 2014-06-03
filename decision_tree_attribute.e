note
	description: "Summary description for {DECISION_TREE_ATTRIBUTE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECISION_TREE_ATTRIBUTE [G -> ANY]

inherit
	ML_FORMULA

create
	make

feature -- Init

	make (a_key: IMMUTABLE_STRING_32; a_labels: ARRAY [G]; a_tree: DECISION_TREE)
		do
			key := a_key
			decision_tree := a_tree
			create labels.make_from_array (a_labels)
		end

feature -- Access

	key: IMMUTABLE_STRING_32

	decision_tree: DECISION_TREE

	labels: ARRAYED_LIST [G]
			-- Possible values for Current.
		attribute
			create Result.make (0)
		end

	label_count: INTEGER
			-- How mand values does Current have?
		do
			Result := labels.count
		end

	values_count: INTEGER
			-- How many data values are in `values_from_data'?
		do
			Result := values_from_data.count
		end

	training_value_at (a_index: INTEGER): G
			-- Value of training data at an index.
		do
			Result := values_from_data.at (a_index)
		end

	information_gain: REAL_64
			-- Information gained from using Current.
		do
			Result := (decision_tree.entropy_for_set) - attribute_entropy_summation
		end

feature -- Status Report

	are_labels_the_same (a_label, a_other_label: G): BOOLEAN
			-- Are these two labels the same?
		do
			if attached {READABLE_STRING_GENERAL} a_label as al_string and then attached {READABLE_STRING_GENERAL} a_other_label as al_other_string then
				Result := al_string.same_string (al_other_String)
			else
				Result := a_label = a_other_label
			end
		end

feature -- Basic Operations

	extend_to_training_data (a_value: G)
			-- Extends a value into the training data.
		do
			values_from_data.extend (a_value)
		end

feature {NONE} -- Implementation

	attribute_entropy_summation: REAL_64
		local
			l_count_tuple: like positive_negative_count_tuple
			l_total_count_for_label: INTEGER
		do
			across labels as ic_labels loop
				l_count_tuple := positive_negative_count_for_label (ic_labels.item)
				l_total_count_for_label := l_count_tuple.positive_count + l_count_tuple.negative_count
				Result := Result + ( ( (l_total_count_for_label / decision_tree.results.count) * (entropy_of (l_count_tuple.positive_count, l_count_tuple.negative_count))))
			end
		end

	positive_negative_count_for_label (a_label: G): attached like positive_negative_count_tuple
		do
			create Result
			across values_from_data as ic_data loop
				if are_labels_the_same (ic_data.item, a_label) and then decision_tree.results.at (ic_data.cursor_index) then
 					Result.positive_count := Result.positive_count + 1
 				elseif are_labels_the_same (ic_data.item, a_label) then
 					Result.negative_count := Result.negative_count + 1
				end
			end
		end

	values_from_data: ARRAYED_LIST [G]
			-- List of label values for Current training set.
		attribute
			create Result.make (0)
		ensure
			string_values_contained_in_labels: across Result as ic_result all labels.has (ic_result.item) end
		end

	positive_negative_count_tuple: detachable TUPLE [positive_count, negative_count: INTEGER]
			-- Type anchor to hold a positive and negative count in a tuple.

end
