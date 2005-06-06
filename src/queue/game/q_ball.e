indexing
	description: "Physical ball representation"
	author: "Andreas Kaegi"

class
	Q_BALL

inherit
	Q_OBJECT
	redefine
		bounding_object
	end
	
create
	make,
	make_empty
	
feature {NONE} -- create

	make_empty is
		do
			bounding_object := create {Q_BOUNDING_CIRCLE}.make_empty
		end
		
	
	make (center_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Create new ball.
		require
			center_ /= void
			radius_ >= 0
		do
			create bounding_object.make (center_, radius_)
			
			-- e.g. to calculate radvec
			set_radius (radius_)
		end


feature -- interface

	color : INTEGER -- the color of the ball
	number: INTEGER -- the number of the ball, 0 is the white ball
	owner : LINKED_LIST[Q_PLAYER] -- the owners of the ball, null if no owner yet specified, usually the list has only one owner
	ball_model : Q_BALL_MODEL -- the 3d model of this ball
	
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
		
	add_owner(owner_: Q_PLAYER) is
			-- Set the owner of the ball (null means that the ball belongs to nobody yet)
		do
			owner.force (owner_)
		end

	set_ball_model (ball_model_:Q_BALL_MODEL) is
			-- set the ball model of this ball
		do
			ball_model := ball_model_
		end

	update_position (step: DOUBLE) is
			-- Update object position for one time step (given in ms).
		local
			c: Q_VECTOR_2D
			wr, mom, om: Q_VECTOR_3D
			f_sf, f_rf, f, a: Q_VECTOR_2D
		do
			-- F_sf = mu_sf * Fn * (w x r + v)
			wr := angular_velocity.cross (radvec)
			f_sf := (dim3_to_dim2 (wr) + velocity) * sf_const
			
			-- F_rf = mu_rf * Fn * (v / |v|)
			f_rf := (velocity / velocity.length) * rf_const
			
			f := f_sf + f_rf
			
			-- f = a*m
			-- > Calculate velocity dv = a*t --> v[new] = a*t + v[old]
			a := f / mass
			
			velocity := velocity + (a * step)
			
			-- v = s/t --> s = v * t
			c := center + velocity * step
			io.put_string (c.out)
			io.put_new_line
			
			set_center (c)
			
			-- New angular velocity
			-- f = a*m --> M = Om*Th
			-- M = r x F
			mom := radvec.cross ( dim2_to_dim3 (f) )
			om := mom / theta
			
			-- angular_velocity := angular_velocity + (om * step)
			
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
			bounding_object.set_center(c)
		end
		
	set_radius (r: DOUBLE) is
			-- Set radius of ball.
		require
			r >= 0
		do
			radvec := create {Q_VECTOR_3D}.make (0, -1 * radius, 0)
			theta  := 2/5 * mass * r*r
		
			bounding_object.set_radius(r)
		end
		
	set_velocity (v: Q_VECTOR_2D) is
			-- Set velocity of ball.
		require
			v /= void
		do
			velocity := v
		end
		
	set_angular_velocity (av: Q_VECTOR_3D) is
			-- Set angular velocity of ball.
		require
			av /= void
		do
			angular_velocity := av
		end
		
	center: Q_VECTOR_2D is
			-- Center of ball
		do
			result := bounding_object.center
		end
		
	radius: DOUBLE is
			-- Radius of ball
		do
			result := bounding_object.radius
		end
		
	bounding_object: Q_BOUNDING_CIRCLE
		
	velocity: Q_VECTOR_2D
			-- Velocity of ball
			
	angular_velocity: Q_VECTOR_3D
			-- Angular velocity of ball
	
	typeid: INTEGER is 1
			-- Type id for collision response
			
	
feature {NONE} -- implementation
	
	physics: Q_PHYSICS is
			-- Physics helper functions
		once
			Result := create {Q_PHYSICS}
		end
	
	radvec: Q_VECTOR_3D
			-- Radius vector
	
	mass: DOUBLE is 0.2
	
	theta: DOUBLE
			-- Theta would actually be a matrix.
			-- But since the matrix is the identify matrix for a ball it can
			-- be reduced to a real number	
	
	mu_sf: DOUBLE is 0.05
			-- Sliding friction constant (Gleitreibung)
			
	mu_rf: DOUBLE is 0.01
			-- Rolling friction constant (Rollreibung)
	
	sf_const: DOUBLE is
			-- Constant part of sliding friction: mu_sf * fn
		once
			Result := mu_sf * physics.force_normal_val (mass)
		end
		
	rf_const: DOUBLE is
			-- Constant part of rolling friction: mu_rf * fn
		once
			Result := mu_rf * physics.force_normal_val (mass)
		end
		
	dim3_to_dim2 (v: Q_VECTOR_3D): Q_VECTOR_2D is
			-- Temporary converter!!!
		do
			Result := create {Q_VECTOR_2D}.make (v.x, v.z)
		end
		
	dim2_to_dim3 (v: Q_VECTOR_2D): Q_VECTOR_3D is
			-- Temporary converter!!!
		do
			Result := create {Q_VECTOR_3D}.make (v.x, 0, v.y)
		end
		
	
end -- class Q_BALL
