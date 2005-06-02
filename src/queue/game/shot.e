indexing
	description: "Objects that represent a physical shot with direction and strength"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_SHOT
	
create
	make,
	make_empty
	
feature -- Interface

	make (dir_: Q_VECTOR_2D) is
			-- create a shot with direction vector
		do
			direction := dir_
		end
		
	make_empty is
			-- create a default shot
		do
			
		end
		
	direction: Q_VECTOR_2D -- the direction of the shot in (x,y) coordinates
	
	-- hackers: commented out because strength = |direction| = length of direction vector
	--strength : REAL -- the strength of the shot
	
	set_direction(direction_:Q_VECTOR_2D) is
			-- sets the new direction of the shot
		require
			direction_exist : direction /= Void
		do
			direction := direction_
		ensure
			direction = direction_
		end
	
	-- hackers: commented out because strength = |direction| = length of direction vector
--	set_strength(strength_:REAL) is
--			-- sets the strength of the shot
--		require
--			strength_exist : strength /= Void
--			pos_strength: strength_ > 0
--		do
--			strength := strength_
--		ensure
--			strength = strength_
--		end
		

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class SHOT
