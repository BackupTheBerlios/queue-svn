indexing
	description: "Bounding box: circle"
	author: "Andreas Kaegi"

class
	Q_BOUNDING_CIRCLE

inherit
	Q_BOUNDING_OBJECT

create
	make, 
	make_empty
	
feature {NONE} -- create

	make_empty is
			-- Make empty bounding circle.
		do
		end
		
	make (center_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Make bounding circle.
		require
			center_ /= void
			radius_ >= 0
		do
			center := center_
			radius := radius_
		end

feature -- interface

	set_center (c: Q_VECTOR_2D) is
			-- Set center to 'c'.
		require
			c /= void
		do
			center := c
		end
		
	set_radius (r: DOUBLE) is
			-- Set radius to 'r'.
		require
			r >= 0
		do
			radius := r
		end
		
	center: Q_VECTOR_2D
			-- Center of bounding circle
			
	radius: DOUBLE
			-- Radius of bounding circle
	
	typeid: INTEGER is 1
			-- Type id for collision detection

end -- class Q_BOUNDING_CIRCLE
