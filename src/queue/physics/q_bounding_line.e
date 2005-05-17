indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
	
end -- class Q_BOUNDING_LINE
