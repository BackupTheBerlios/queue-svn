indexing
	description: "Superclass for physical objects."
	author: "Andreas Kaegi"

deferred class
	Q_OBJECT
	
feature -- interface

	update_position (step: DOUBLE) is
			-- Update object position for one time step (given in ms).
		require
			step > 0
		deferred
		end

	on_collide (other: like Current) is
			-- Collisionn with other detected!
		require
			other /= void
		deferred
		end

	set_bounding_object (bo: Q_BOUNDING_OBJECT) is
			-- Assign new bounding object.
		require
			bo /= void
		do
			bounding_object := bo	
		end
		
	bounding_object: Q_BOUNDING_OBJECT
			-- Currently assigned bounding object
			
	typeid: INTEGER is
			-- Makes life easy :-) (Collision response)
		deferred
		end	

end -- class Q_OBJECT
