note
	description: "Summary description for {ML_FORMULA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ML_FORMULA

inherit
	SINGLE_MATH

feature -- Access

	entropy_of (a_pos_instances, a_neg_instances: INTEGER): REAL_64
		local
			l_total: INTEGER
		do
			l_total := a_neg_instances + a_pos_instances
			Result := -((a_pos_instances/l_total)*log_2 (( (a_pos_instances / l_total).truncated_to_real ))) - ((a_neg_instances/l_total)*log_2 ( (a_neg_instances / l_total).truncated_to_real ))
		end

end
