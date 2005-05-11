indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_OBJECT
	
feature -- interface

	update_position(step: DOUBLE) is
			-- update object position for one time step (given in ms)
		deferred
		end

	on_collide(other: like Current) is
			-- Collisionn with other detected!
		deferred
		end
		
	typeid: INTEGER is
			-- Not beautiful I know, but easier for the collision detector
			-- to distinguish between the different subclasses
		deferred
		end		

end -- class Q_OBJECT
