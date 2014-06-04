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

	entropy_of (a_pos_instances, a_neg_instances: INTEGER): REAL_32
		local
			l_total: INTEGER
			l_neg_proportion, l_pos_proportion, l_pos_log, l_neg_log: REAL_32
		do
			if a_pos_instances = 0 and then a_neg_instances = 0 then
				Result := 0
			else
				l_total := a_neg_instances + a_pos_instances
				l_neg_proportion := (a_neg_instances/l_total).truncated_to_real
				l_pos_proportion := (a_pos_instances/l_total).truncated_to_real
				if a_pos_instances / l_total <= 0 then
					l_pos_log := 0
				else
					l_pos_log := log_2 ((a_pos_instances / l_total).truncated_to_real)
				end
				if a_neg_instances / l_total <= 0 then
					l_neg_log := 0
				else
					l_neg_log := log_2 ((a_neg_instances / l_total).truncated_to_real)
				end
				Result := -(l_pos_proportion * l_pos_log)  -
							(l_neg_proportion * l_neg_log)
			end
		end

end
