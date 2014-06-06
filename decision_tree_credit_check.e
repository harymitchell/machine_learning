note
	description: "[
					{DECISION_TREE_CREDIT_CHECK} is a specialized implementation ofa DECISION TREE,
					which uses 1000 instances data with 20 attributes 
					(found here: http://archive.ics.uci.edu/ml/datasets/Statlog+%28German+Credit+Data%29),
					to build a decision tree predict the fate of a creit application.
				]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DECISION_TREE_CREDIT_CHECK

inherit
	DECISION_TREE
		redefine
			parse_data_file,
			make_with_csv_file_path
		end

create
	make_with_csv_file_path

feature -- init

	make_with_csv_file_path (a_path_string: STRING_32)
		do
			Precursor (a_path_string)
			set_atribute_keys_and_labels
			syntesize_results
		end

feature -- Imp

	parse_data_file (a_path_string: STRING_32)
		do
			Precursor (a_path_string)
		end

	syntesize_results
			-- Take the raw results and turns them into BOOLEAN values.
			-- In this case, 1 is good (True) and 2 is bad (False).
		do
			across raw_results as ic_results loop
				check attached {READABLE_STRING_GENERAL} ic_results.item as al_string then
					if al_string.same_string ("1") then
						results.extend (True)
					elseif al_string.same_string ("2") then
						results.extend (False)
					else
						check unexpected_results_value: False end
					end
				end
			end
		end

	set_atribute_keys_and_labels
			-- Get our bearings by setting our attributes with a key and labels.
		do
			attributes.at (1).set_key ("status_existing_credit_account")
			attributes.at (1).set_labels_from_array (<<"A1","A12","A13","A14">>)

			attributes.at (2).set_key ("month_duration")
			attributes.at (2).set_labels_from_array (<<numerical_string>>)

			attributes.at (3).set_key ("credit_history")
			attributes.at (3).set_labels_from_array (<<"A30","A31","A32","A33", "A34">>)

			attributes.at (4).set_key ("purpose")
			attributes.at (4).set_labels_from_array (<<"A40","A41","A42","A43","A44","A45","A46","A47","A48","A49","A410">>)

			attributes.at (5).set_key ("credit_amount")
			attributes.at (5).set_labels_from_array (<<numerical_string>>)

			attributes.at (6).set_key ("bonds")
			attributes.at (6).set_labels_from_array (<<"A61","A62","A63","A64", "A65">>)

			attributes.at (7).set_key ("employed_since")
			attributes.at (7).set_labels_from_array (<<"A71","A72","A73","A74", "A75">>)

			attributes.at (8).set_key ("installment_rate_percentage_of_income")
			attributes.at (8).set_labels_from_array (<<numerical_string>>)

			attributes.at (9).set_key ("status_and_sex")
			attributes.at (9).set_labels_from_array (<<"A91","A92","A93","A94", "A95">>)

			attributes.at (10).set_key ("other_debtors_or_guarantors")
			attributes.at (10).set_labels_from_array (<<"A101","A102","103">>)

			attributes.at (11).set_key ("resident_since")
			attributes.at (11).set_labels_from_array (<<numerical_string>>)

			attributes.at (12).set_key ("property")
			attributes.at (12).set_labels_from_array (<<"A121","A122","A123","A124">>)

			attributes.at (13).set_key ("age")
			attributes.at (13).set_labels_from_array (<<numerical_string>>)

			attributes.at (14).set_key ("other_installment_plans")
			attributes.at (14).set_labels_from_array (<<"A141","A142","A143">>)

			attributes.at (15).set_key ("housing")
			attributes.at (15).set_labels_from_array (<<"A151","A152","A153">>)

			attributes.at (16).set_key ("existing_credits")
			attributes.at (16).set_labels_from_array (<<numerical_string>>)

			attributes.at (17).set_key ("job")
			attributes.at (17).set_labels_from_array (<<"A171","A172","A173","A174">>)

			attributes.at (18).set_key ("number_of_people_liable_for_maintenance")
			attributes.at (18).set_labels_from_array (<<numerical_string>>)

			attributes.at (19).set_key ("telephone")
			attributes.at (19).set_labels_from_array (<<"A191","A192">>)

			attributes.at (20).set_key ("foreign_worker")
			attributes.at (20).set_labels_from_array (<<"A201", "A202">>)

		end

	numerical_string: STRING = "numerical"

note

	glossary: "[
Attribute Information:

Attribute 1: (qualitative) 
Status of existing checking account 
A11 : ... < 0 DM 
A12 : 0 <= ... < 200 DM 
A13 : ... >= 200 DM / salary assignments for at least 1 year 
A14 : no checking account

Attribute 2: (numerical) 
Duration in month

Attribute 3: (qualitative) 
Credit history 
A30 : no credits taken/ all credits paid back duly 
A31 : all credits at this bank paid back duly 
A32 : existing credits paid back duly till now 
A33 : delay in paying off in the past 
A34 : critical account/ other credits existing (not at this bank)

Attribute 4: (qualitative) 
Purpose 
A40 : car (new) 
A41 : car (used) 
A42 : furniture/equipment 
A43 : radio/television 
A44 : domestic appliances 
A45 : repairs 
A46 : education 
A47 : (vacation - does not exist?) 
A48 : retraining 
A49 : business 
A410 : others

Attribute 5: (numerical) 
Credit amount

Attibute 6: (qualitative) 
Savings account/bonds 
A61 : ... < 100 DM 
A62 : 100 <= ... < 500 DM 
A63 : 500 <= ... < 1000 DM 
A64 : .. >= 1000 DM 
A65 : unknown/ no savings account

Attribute 7: (qualitative) 
Present employment since 
A71 : unemployed 
A72 : ... < 1 year 
A73 : 1 <= ... < 4 years 
A74 : 4 <= ... < 7 years 
A75 : .. >= 7 years

Attribute 8: (numerical) 
Installment rate in percentage of disposable income

Attribute 9: (qualitative) 
Personal status and sex 
A91 : male : divorced/separated 
A92 : female : divorced/separated/married 
A93 : male : single 
A94 : male : married/widowed 
A95 : female : single

Attribute 10: (qualitative) 
Other debtors / guarantors 
A101 : none 
A102 : co-applicant 
A103 : guarantor

Attribute 11: (numerical) 
Present residence since

Attribute 12: (qualitative) 
Property 
A121 : real estate 
A122 : if not A121 : building society savings agreement/ life insurance 
A123 : if not A121/A122 : car or other, not in attribute 6 
A124 : unknown / no property

Attribute 13: (numerical) 
Age in years

Attribute 14: (qualitative) 
Other installment plans 
A141 : bank 
A142 : stores 
A143 : none

Attribute 15: (qualitative) 
Housing 
A151 : rent 
A152 : own 
A153 : for free

Attribute 16: (numerical) 
Number of existing credits at this bank

Attribute 17: (qualitative) 
Job 
A171 : unemployed/ unskilled - non-resident 
A172 : unskilled - resident 
A173 : skilled employee / official 
A174 : management/ self-employed/ 
highly qualified employee/ officer

Attribute 18: (numerical) 
Number of people being liable to provide maintenance for

Attribute 19: (qualitative) 
Telephone 
A191 : none 
A192 : yes, registered under the customers name

Attribute 20: (qualitative) 
foreign worker 
A201 : yes 
A202 : no 	

]"

end
