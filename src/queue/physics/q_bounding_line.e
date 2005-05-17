indexing
	description: "Bounding box: line"
	author: "Andreas Kaegi"

class
	Q_BOUNDING_LINE

inherit
	Q_BOUNDING_OBJECT
	Q_LINE_2D
	
create
	make,
	make_empty
	
feature -- interface

	typeid: INTEGER is 2
			-- Type id for collision detection
	
end -- class Q_BOUNDING_LINE
