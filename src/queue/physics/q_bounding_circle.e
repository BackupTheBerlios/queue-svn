indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_BOUNDING_CIRCLE

inherit
	Q_BOUNDING_OBJECT

create
	make, 
	make_empty
	
feature {NONE} -- create

	make_empty is
		do
		end
		
	make (center_: Q_VECTOR_2D; radius_: DOUBLE) is
		require
			center_ /= void
			radius_ >= 0
		do
			center := center_
			radius := radius_
		end

feature -- interface

	set_center (c: Q_VECTOR_2D) is
		require
			c /= void
		do
			center := c
		end
		
	set_radius (r: DOUBLE) is
		require
			r >= 0
		do
			radius := r
		end
		
	center: Q_VECTOR_2D
	radius: DOUBLE
	
	typeid: INTEGER is 1

end -- class Q_BOUNDING_CIRCLE
