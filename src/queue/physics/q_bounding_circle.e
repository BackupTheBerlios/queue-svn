indexing
	description: "Bounding box: circle"
	author: "Andreas Kaegi"

class
	Q_BOUNDING_CIRCLE

inherit
	Q_BOUNDING_OBJECT
	redefine
		copy
	end

create
	make, 
	make_empty
	
feature -- create

	make_empty is
			-- Make empty bounding circle.
		do
			create center.default_create
		end
		
	make (center_, center_old_, velocity_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Make bounding circle.
		require
			center_ /= Void
			center_old_ /= Void
			radius_ >= 0
		do
			center := center_
			center_old := center_old_
			velocity := velocity_
			radius := radius_
		end
		
	copy (other: like Current) is
		do
			center.make_from_other (other.center)
			radius := other.radius
			center_old := other.center_old
		end
		

feature -- interface

	set_center (c: Q_VECTOR_2D) is
			-- Set center to 'c'.
		require
			c /= Void
		do
			center := c
		end
	
	set_center_old (c: Q_VECTOR_2D) is
			-- Set old center to 'c'.
		require
			c /= Void
		do
			center_old := c
		end
		
	set_velocity (v: Q_VECTOR_2D) is
			-- Set velocity to 'v'.
		require
			v /= Void
		do
			velocity := v
		end
		
	set_radius (r: DOUBLE) is
			-- Set radius to 'r'.
		require
			r >= 0
		do
			radius := r
		end

	center: Q_VECTOR_2D
			-- Center of bounding circle
	
	center_old: Q_VECTOR_2D
			-- Old center of bounding circle
	
	velocity: Q_VECTOR_2D
			-- Velocity of bounding circle
			
	radius: DOUBLE
			-- Radius of bounding circle
	
	typeid: INTEGER is 1
			-- Type id for collision detection

end -- class Q_BOUNDING_CIRCLE
