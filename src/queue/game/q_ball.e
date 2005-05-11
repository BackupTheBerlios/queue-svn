indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_BALL

inherit
	Q_OBJECT
	
create make
	
feature -- interface

	center: Q_VECTOR_2D
	radius: DOUBLE
	
	velocity: Q_VECTOR_2D
	angular_velocity: Q_VECTOR_2D
	
	make(center_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Create new ball
		do
			center := center_
			radius := radius_
		end
		
	update_position(step: DOUBLE) is
		do
			-- v = s/t --> s = v * t
			center := center + velocity * step
			
		end
		
	on_collide(other: like Current) is
			-- Collisionn with other detected!
		do
			velocity := velocity * 0
		end		
		
	typeid: INTEGER is
		once
			Result := 1
		end
		
	

end -- class Q_BALL
