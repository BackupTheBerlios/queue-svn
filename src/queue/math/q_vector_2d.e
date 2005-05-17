indexing
	description: "2 dimensional vector"
	author: "Andreas Kaegi"

class
	Q_VECTOR_2D

inherit
	VECTOR_2D
	redefine
		default_create
	end

create
	default_create,
	make, 
	make_from_other,
	make_moved, 
	make_distance
	
feature {NONE} -- create

	default_create is
			-- Make vector with initial position zero.
		do
			make (0, 0)
		end
		
	
feature -- interface

end -- class Q_VECTOR_2D

