note
	description: "Summary description for {DECISION_TREE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECISION_TREE
inherit
	ML_FORMULA

feature -- Access

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

	entropy_for_set: REAL_32
			-- Entropy for Current.
		do
			Result := entropy_of (positive_outcome_count, negative_outcome_count)
		end

feature -- Test

	test_decision_tree
		local
			l_outlook_att: DECISION_TREE_ATTRIBUTE [STRING_32]
			l_humidity_att: DECISION_TREE_ATTRIBUTE [INTEGER_32]
			l_wind_att: DECISION_TREE_ATTRIBUTE [STRING_32]
			l_temp_att: DECISION_TREE_ATTRIBUTE [STRING_32]
		do
			create l_outlook_att.make ("outlook", <<"sunny", "overcast", "rain">>, Current)
			create l_humidity_att.make ("humidity", <<0,1>>, Current)
			create l_wind_att.make ("wind", <<"strong", "weak">>, Current)
			create l_temp_att.make ("temp", <<"hot", "mild", "cool">>, Current)

			results.extend (False)
			results.extend (False)
			results.extend (True)
			results.extend (True)
			results.extend (True)
			results.extend (False)
			results.extend (True)
			results.extend (False)
			results.extend (True)
			results.extend (True)
			results.extend (True)
			results.extend (True)
			results.extend (True)
			results.extend (False)

			l_outlook_att.extend_to_training_data ("sunny")
			l_outlook_att.extend_to_training_data ("sunny")
			l_outlook_att.extend_to_training_data ("overcast")
			l_outlook_att.extend_to_training_data ("rain")
			l_outlook_att.extend_to_training_data ("rain")
			l_outlook_att.extend_to_training_data ("rain")
			l_outlook_att.extend_to_training_data ("overcast")
			l_outlook_att.extend_to_training_data ("sunny")
			l_outlook_att.extend_to_training_data ("sunny")
			l_outlook_att.extend_to_training_data ("rain")
			l_outlook_att.extend_to_training_data ("sunny")
			l_outlook_att.extend_to_training_data ("overcast")
			l_outlook_att.extend_to_training_data ("overcast")
			l_outlook_att.extend_to_training_data ("rain")

			l_humidity_att.extend_to_training_data (1)
			l_humidity_att.extend_to_training_data (1)
			l_humidity_att.extend_to_training_data (1)
			l_humidity_att.extend_to_training_data (1)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (1)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (1)
			l_humidity_att.extend_to_training_data (0)
			l_humidity_att.extend_to_training_data (1)

			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("strong")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("strong")
			l_wind_att.extend_to_training_data ("strong")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("strong")
			l_wind_att.extend_to_training_data ("strong")
			l_wind_att.extend_to_training_data ("weak")
			l_wind_att.extend_to_training_data ("strong")

			l_temp_att.extend_to_training_data ("hot")
			l_temp_att.extend_to_training_data ("hot")
			l_temp_att.extend_to_training_data ("hot")
			l_temp_att.extend_to_training_data ("mild")
			l_temp_att.extend_to_training_data ("cool")
			l_temp_att.extend_to_training_data ("cool")
			l_temp_att.extend_to_training_data ("cool")
			l_temp_att.extend_to_training_data ("mild")
			l_temp_att.extend_to_training_data ("cool")
			l_temp_att.extend_to_training_data ("mild")
			l_temp_att.extend_to_training_data ("mild")
			l_temp_att.extend_to_training_data ("mild")
			l_temp_att.extend_to_training_data ("hot")
			l_temp_att.extend_to_training_data ("mild")

			check l_humidity_att.values_count = results.count and then  l_outlook_att.values_count = results.count  and then  l_temp_att.values_count = results.count  and then  l_wind_att.values_count = results.count end

			entropy_for_set.do_nothing

			l_temp_att.information_gain.do_nothing
			l_wind_att.information_gain.do_nothing
			l_outlook_att.information_gain.do_nothing
			l_humidity_att.information_gain.do_nothing
		end

end
