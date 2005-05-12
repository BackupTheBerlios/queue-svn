indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_BANK

inherit
	Q_LINE_2D

feature -- interface

	update_position(step: DOUBLE) is
		do
			
		end
	
	on_collide(other: like Current) is
			-- Collisionn with other detected!
		do
		end
		
	typeid: INTEGER is
		once
			Result := 2
		end

end -- class Q_BANK
