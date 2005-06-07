indexing
	description: "Objects that represent a physical shot with direction and strength"
	author: "Severin Hacker"

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
		
	set_hitpoint (h: Q_VECTOR_3D) is
			-- Set hitpoint to h.
		require
			h /= Void
		do
			hitpoint := h
		end
	
	set_direction (direction_: Q_VECTOR_2D) is
			-- sets the new direction of the shot
		require
			direction_exist : direction /= Void
		do
			direction := direction_
		ensure
			direction = direction_
		end
		
	-- hit_plane : Q_PLANE
	
--	set_hit( point_ : Q_VECTOR_3D; plane_ : Q_PLANE ) is
--		do
--			hit_point := point_
--			hit_plane := plane_
--		end
--		
	
	-- hackers: commented out because strength = |direction| = length of direction vector
	--strength : REAL -- the strength of the shot
	
	
	
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
		
	direction: Q_VECTOR_2D
			-- Direction of the shot in (x,y) coordinates
	
	hitpoint : Q_VECTOR_3D
			-- Hit point of the queue on the ball surface
			
feature {NONE} -- implementation

end -- class SHOT
