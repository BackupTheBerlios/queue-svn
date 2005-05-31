indexing
	description: "Physical ball representation"
	author: "Andreas Kaegi"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_BALL

inherit
	Q_OBJECT
	
create
	make,
	make_empty
	
feature {NONE} -- create

	make_empty is
		do
			create bounding_circle.make_empty
			bounding_object := bounding_circle
		end
		
	
	make (center_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Create new ball.
		require
			center_ /= void
			radius_ >= 0
		do
			create bounding_circle.make (center_, radius_)
			bounding_object := bounding_circle
		end


feature -- interface

	color : INTEGER -- the color of the ball
	number: INTEGER -- the number of the ball, 0 is the white ball
	owner : Q_PLAYER -- the owner of the ball, null if no owner yet specified


	set_color(color_:INTEGER) is
			-- Set the color of the ball
		require
		do
			color := color_
		end
		
	set_number (number_: INTEGER) is
			-- Set the number of the ball (if used)
		require
			number_>= 0
		do
			number := number_
		end
		
	set_owner(owner_: Q_PLAYER) is
			-- Set the owner of the ball (null means that the ball belongs to nobody yet)
		do
			owner := owner_
		end

	update_position (step: DOUBLE) is
			-- Update object position for one time step (given in ms).
		local
			c: Q_VECTOR_2D
		do
			-- v = s/t --> s = v * t
			c := bounding_circle.center + velocity * step
			bounding_circle.set_center (c)
		end
		
	on_collide (other: like Current) is
			-- Collisionn with other detected!
		do
			
		end
	
	set_center (c: Q_VECTOR_2D) is
			-- Set center of ball.
		require
			c /= void
		do
			bounding_circle.set_center(c)
		end
		
	set_radius (r: DOUBLE) is
			-- Set radius of ball.
		require
			r >= 0
		do
			bounding_circle.set_radius(r)
		end
		
	set_velocity (v: Q_VECTOR_2D) is
			-- Set velocity of ball.
		require
			v /= void
		do
			velocity := v
		end
		
	set_angular_velocity (av: Q_VECTOR_2D) is
			-- Set angular velocity of ball.
		require
			av /= void
		do
			angular_velocity := av
		end
		
	center: Q_VECTOR_2D is
			-- Center of ball
		do
			result := bounding_circle.center
		end
		
	radius: DOUBLE is
			-- Radius of ball
		do
			result := bounding_circle.radius
		end
		
	
	velocity: Q_VECTOR_2D
			-- Velocity of ball
			
	angular_velocity: Q_VECTOR_2D
			-- Angular velocity of ball
	
	typeid: INTEGER is 1
			-- Type id for collision response
			
	
feature {NONE}-- implementation
		
	bounding_circle: Q_BOUNDING_CIRCLE
	
end -- class Q_BALL
