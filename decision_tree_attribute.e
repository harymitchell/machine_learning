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

	information_gain: REAL_32
			-- Information gained from using Current.
		do
			Result := (decision_tree.entropy_for_set) - attribute_entropy_summation
		end

feature -- Status Report

	do_labels_match (a_label, a_other_label: G): BOOLEAN
			-- Are these two labels the same?
		do
			if not is_continuous_value and then not is_candidate_attribute and then attached {READABLE_STRING_GENERAL} a_label as al_string and then attached {READABLE_STRING_GENERAL} a_other_label as al_other_string then
				Result := al_string.same_string (al_other_String)
			elseif not is_continuous_value and then not is_candidate_attribute then
				Result := a_label = a_other_label
			elseif is_continuous_value or is_candidate_attribute then
				Result := are_continuous_value_labels_matched (a_label, a_other_label)
			end
		end

	are_continuous_value_labels_matched (a_label, a_threshold_label: G): BOOLEAN
			-- Does a_label meet a_threshold_label?
		do
			Result := attached {READABLE_STRING_GENERAL} a_label as al_string and then attached {READABLE_STRING_GENERAL} a_threshold_label as al_threshold_string and then
						al_string.to_integer >= al_threshold_string.to_integer
		end

	is_continuous_value: BOOLEAN
			-- Is this attribute a continuous/ numerical value?
		do
			Result := label_count = 1 and then attached {READABLE_STRING_GENERAL} labels.at (1) as al_string and then al_string.same_string (numerical_string)
		end

	is_candidate_attribute: BOOLEAN

feature -- Settings

	set_key (a_key: like key)
		do
			key := a_key
		ensure
			key = a_key
		end

	set_labels_from_array (a_array_of_labels: ARRAY [G])
		local
			l_labels: like labels
		do
			create l_labels.make_from_array (a_array_of_labels)
			labels := l_labels
		end

	set_is_candidate_attribute (a_is_candidate: BOOLEAN)
		do
			is_candidate_attribute := a_is_candidate
		end

feature -- Basic Operations

	extend_to_training_data (a_value: G)
			-- Extends a value into the training data.
		do
			values_from_data.extend (a_value)
--		ensure
--			string_values_contained_in_labels: across values_from_data as ic_result all
--												across labels as ic_labels some are_labels_the_same (ic_labels.item, ic_result.item) end
--											   end
		end

feature {NONE} -- Implementation

	attribute_entropy_summation: REAL_32
			-- Summation of the entropy of all labels by the proportion of each label (for discrete values).
		do
			-- Determine labels.
			if not is_continuous_value then
				Result := entropy_summation_for_labels (labels)
			else
				Result := entropy_summation_continuous_values
			end
		end

	entropy_summation_for_labels (a_labels: like labels): REAL_32
		local
			l_count_tuple: like positive_negative_count_tuple
			l_total_count_for_label: INTEGER
			l_labels: like labels
		do
			-- Compute summation.
			across a_labels as ic_labels loop
				l_count_tuple := positive_negative_count_for_label (ic_labels.item)
				l_total_count_for_label := l_count_tuple.positive_count + l_count_tuple.negative_count
				Result := Result + ( ( (l_total_count_for_label / decision_tree.results.count) * (entropy_of (l_count_tuple.positive_count, l_count_tuple.negative_count)))).truncated_to_real
			end
		end

	entropy_summation_continuous_values: REAL_32
		do

		end

	best_candidate_attribute_for_continuous_value: DECISION_TREE_ATTRIBUTE [INTEGER]
			-- Computed labels for continous data.
		local
			l_gain, l_candidate_gain: REAL
			l_candidate_threshold: INTEGER
			l_candidate_attribute: DECISION_TREE_ATTRIBUTE [INTEGER]
		do
			across values_from_data as ic_data loop
				if attached {READABLE_STRING_GENERAL} ic_data.item as al_string and then al_string.is_number_sequence then
					l_candidate_threshold := al_string.to_integer
					create l_candidate_attribute.make (numerical_string, <<l_candidate_threshold>>, decision_tree)
					l_candidate_attribute.set_is_candidate_attribute (True)
					l_candidate_gain := l_candidate_attribute.information_gain
					if l_candidate_gain > l_gain then
						l_gain := l_candidate_gain
						Result := l_candidate_threshold
					end
				end
			end
		end

	positive_negative_count_for_label (a_label: G): attached like positive_negative_count_tuple
			-- The positive and negative result count for `a_label'.
		do
			create Result
			across values_from_data as ic_data loop
				if do_labels_match (ic_data.item, a_label) and then decision_tree.results.at (ic_data.cursor_index) then
 					Result.positive_count := Result.positive_count + 1
 				elseif do_labels_match (ic_data.item, a_label) then
 					Result.negative_count := Result.negative_count + 1
				end
			end
		end

	values_from_data: ARRAYED_LIST [G]
			-- List of label values for Current training set.
		attribute
			create Result.make (0)
		end

	positive_negative_count_tuple: detachable TUPLE [positive_count, negative_count: INTEGER]
			-- Type anchor to hold a positive and negative count in a tuple.

	numerical_string: STRING = "numerical"

	candidate_string: STRING = "candidate"

end
