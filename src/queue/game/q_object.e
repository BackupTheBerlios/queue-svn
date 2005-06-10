indexing
	description: "Superclass for physical objects."
	author: "Andreas Kaegi"

deferred class
	Q_OBJECT
	
feature -- interface

	do_update_position (step: DOUBLE) is
			-- Update object position for one time step (given in ms).
		require
			step > 0
		do
		end
		
	revert_update_position is
			-- Revert last position update of object
		do
			if old_state /= Void then
				old_state.apply_to (current)
			end
		end

	on_collide (other: like Current) is
			-- Collisionn with other detected!
		require
			other /= void
		do
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

	old_state: Q_PHYS_STATE
			-- Old variables
	
	typeid: INTEGER is
			-- Makes life easy :-) (Collision response)
		deferred
		end	

end -- class Q_OBJECT
