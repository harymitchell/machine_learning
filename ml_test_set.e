note
	description: "Summary description for {ML_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ML_TEST_SET

inherit
	EQA_TEST_SET


feature -- Test

	test_decision_tree_manual_data
			-- Test for {DECISION_TERE}.
		local
			l_outlook_att: DECISION_TREE_ATTRIBUTE [STRING_32]
			l_humidity_att: DECISION_TREE_ATTRIBUTE [STRING_32]
			l_wind_att: DECISION_TREE_ATTRIBUTE [STRING_32]
			l_temp_att: DECISION_TREE_ATTRIBUTE [STRING_32]
		do
			create l_outlook_att.make ("outlook", <<"sunny", "overcast", "rain">>, decision_tree)
			create l_humidity_att.make ("humidity", <<"0","1">>, decision_tree)
			create l_wind_att.make ("wind", <<"strong", "weak">>, decision_tree)
			create l_temp_att.make ("temp", <<"hot", "mild", "cool">>, decision_tree)

			decision_tree.results.extend (False)
			decision_tree.results.extend (False)
			decision_tree.results.extend (True)
			decision_tree.results.extend (True)
			decision_tree.results.extend (True)
			decision_tree.results.extend (False)
			decision_tree.results.extend (True)
			decision_tree.results.extend (False)
			decision_tree.results.extend (True)
			decision_tree.results.extend (True)
			decision_tree.results.extend (True)
			decision_tree.results.extend (True)
			decision_tree.results.extend (True)
			decision_tree.results.extend (False)

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

			l_humidity_att.extend_to_training_data ("1")
			l_humidity_att.extend_to_training_data ("1")
			l_humidity_att.extend_to_training_data ("1")
			l_humidity_att.extend_to_training_data ("1")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("1")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("1")
			l_humidity_att.extend_to_training_data ("0")
			l_humidity_att.extend_to_training_data ("1")

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

			check l_humidity_att.values_count = decision_tree.results.count and then  l_outlook_att.values_count = decision_tree.results.count  and then  l_temp_att.values_count = decision_tree.results.count  and then  l_wind_att.values_count = decision_tree.results.count end

			decision_tree.entropy_for_set.do_nothing

			l_temp_att.information_gain.do_nothing
			l_wind_att.information_gain.do_nothing
			l_outlook_att.information_gain.do_nothing
			l_humidity_att.information_gain.do_nothing
		end

	test_decision_tree_imported_data
			-- Tests {DECISION_TREE} with imported data.
		local
			l_decision_tree: DECISION_TREE_CREDIT_CHECK
		do
			create l_decision_tree.make_with_csv_file_path ("/home/harrison/checkers/data/german.data.txt")
			l_decision_tree.entropy_for_set.do_nothing
			across l_decision_tree.attributes as ic_attributes loop
				ic_attributes.item.information_gain.do_nothing
			end
		end

feature -- Imp

	decision_tree: DECISION_TREE
			attribute
				create Result.default_create
			end


end
