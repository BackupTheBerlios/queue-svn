indexing
	description: "Captures the changing vars of a ball"
	author: "Andreas Kaegi"

class
	Q_PHYS_STATE_BALL

inherit
	Q_PHYS_STATE
	redefine
		apply_to
	end
	
feature -- create

feature -- interface

	assign (bo: Q_BOUNDING_CIRCLE; v: Q_VECTOR_2D; av: Q_VECTOR_3D) is
			-- Create ball state
		do
--			bounding_object := bo.deep_twin
--			velocity := v.twin
--			angular_velocity := av.twin



		end
		
	apply_to (o: Q_BALL) is
			-- Assign variable values to object
		do
			o.set_bounding_object (bounding_object)
			o.set_velocity (velocity)
			o.set_angular_velocity (angular_velocity)
		end

feature {Q_BALL} -- implementation

	bounding_object: Q_BOUNDING_CIRCLE
	
	velocity: Q_VECTOR_2D
	
	angular_velocity: Q_VECTOR_3D
	

end -- class Q_PHYS_STATE_BALL
