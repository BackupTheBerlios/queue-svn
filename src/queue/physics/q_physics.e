indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_PHYSICS

feature -- Interface

	G: DOUBLE is 9.81
			-- Gravitation constant: 9.81 m/(s*s)
			
	force_normal_val (mass: DOUBLE): DOUBLE is
			-- Normal force for mass
		do
			Result := -1 * mass * G
		end
		
end -- class Q_PHYSICS
