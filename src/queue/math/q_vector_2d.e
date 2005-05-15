indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_VECTOR_2D

inherit
	VECTOR_2D
	redefine
		default_create
	end

create
	make, make_from_other, make_moved, make_distance, default_create
	
feature{NONE} -- creation
	default_create is
		do
			make( 0, 0 )
		end
		
	
feature -- interface

end -- class Q_VECTOR_2D
