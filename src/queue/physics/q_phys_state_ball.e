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

create
	make
	
feature -- create

	make is
			-- Creation proc.
		do
			create bounding_object.make_empty
			create velocity.default_create
			create angular_velocity.default_create
		end
		
feature -- interface

	assign (bo: Q_BOUNDING_CIRCLE; v: Q_VECTOR_2D; av: Q_VECTOR_3D) is
			-- Create ball state
		do
--			bounding_object := bo.deep_twin
--			velocity := v.twin
--			angular_velocity := av.twin

			bounding_object.copy (bo)
			velocity.make_from_other (v)
			angular_velocity.make_from (av)

		end
		
	apply_to (o: Q_BALL) is
			-- Assign variable values to object
		do
--			o.set_bounding_object (bounding_object)
--			o.set_velocity (velocity)
--			o.set_angular_velocity (angular_velocity)
			
			o.bounding_object.copy (bounding_object)
			o.velocity.make_from_other (velocity)
			o.angular_velocity.make_from (angular_velocity)
		end

feature {Q_BALL} -- implementation

	bounding_object: Q_BOUNDING_CIRCLE
	
	velocity: Q_VECTOR_2D
	
	angular_velocity: Q_VECTOR_3D
	

end -- class Q_PHYS_STATE_BALL
