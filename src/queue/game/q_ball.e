--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

indexing
	description: "Physical ball representation"
	author: "Andreas Kaegi"

class
	Q_BALL

inherit
	Q_OBJECT
	redefine
		bounding_object,
		on_collide,
		do_update_position,
		is_stationary,
		old_state
	end
	
create
	make,
	make_empty
	
feature -- create

	make_empty is
		do
			create angular_velocity.default_create
			create velocity.default_create
			create owner.make
			create old_state.make
			create bounding_object.make_empty
			bounding_object.set_center_old (old_state.center)
		end
		
	
	make (center_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Create new ball.
		require
			center_ /= void
			radius_ >= 0
		do
			create angular_velocity.default_create
			create velocity.default_create
			create owner.make
			create old_state.make
			create bounding_object.make (center_, old_state.center, radius_)
			
			old_state.assign (bounding_object, velocity, angular_velocity)
		end


feature -- interface
	
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

	do_update_position (step: DOUBLE) is
			-- Update object position for one time step (given in ms).
		local
			wr, mom, om: Q_VECTOR_3D
			f_sf, f_rf, f, a: Q_VECTOR_2D
		do
			if is_moving then
				-- Save old position in state abstraction
				old_state.assign (bounding_object, velocity, angular_velocity)
				
				-- F_sf = mu_sf * Fn * (w x r + v)
				wr := angular_velocity.cross (radvec)	-- w x r
				f_sf := physics.dim3_to_dim2 (wr)
				f_sf.add (velocity)						-- w x r + v
				f_sf.scale (sf_const)					-- mu_sf * Fn * (w x r + v)
	
	
				-- F_rf = mu_rf * Fn * (v / |v|)
				f_rf := velocity.unit_vector
				f_rf.scale (rf_const)
				
				f := f_rf
				f.add (f_sf)							-- f_rf now f_rf + f_sf!!! (performance)
				
				-- f = a*m
				-- > Calculate velocity dv = a*t --> v[new] = a*t + v[old]
				f.scale (1 / mass)
				a := f
				a.scale (step)
				
				velocity.add (a)						-- v = v + (a * step)
				
				-- v = s/t --> s = v * t
				center.add (velocity * step)
				
				-- New angular velocity
				-- f = a*m --> M = Om*Th
				-- M = r x F
				mom := radvec.cross ( physics.dim2_to_dim3 (f_sf) )
				om := mom
				om.scaled (1 / theta)					-- Om = M / Th
				
				angular_velocity.add (om * step)
			else
				velocity.scale (0)
				angular_velocity.scaled (0)
			end
			
			if number = 0 then
				ball0_track.extend (center)
				
--				io.putstring (angular_velocity.out)
--				io.put_new_line
			end
		end
		
	is_moving: BOOLEAN is
			-- Is current ball moving?
		do
			result := False
		
			result := result or (velocity.length > 0.5)
			result := result or (angular_velocity.length > 0.2)
			
			if number = 0 then
--				io.putdouble (velocity.length)
--				io.put_new_line
--				io.putdouble (angular_velocity.length)
--				io.put_new_line
--				io.put_new_line
			end
		end
		
	is_stationary: BOOLEAN is
			-- Is current ball standing still (old pos = new pos)?
		do
			result := old_state.center.is_equal (center)
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
			old_state.assign (bounding_object, velocity, angular_velocity)
			bounding_object.set_center(c)
		end
		
	set_radius (r: DOUBLE) is
			-- Set radius of ball.
		require
			r >= 0
		do
			old_state.assign (bounding_object, velocity, angular_velocity)
			bounding_object.set_radius(r)
		end
		
	set_velocity (v: Q_VECTOR_2D) is
			-- Set velocity of ball.
		require
			v /= void
		do
			old_state.assign (bounding_object, velocity, angular_velocity)
			velocity := v
		end
		
	set_angular_velocity (av: Q_VECTOR_3D) is
			-- Set angular velocity of ball.
		require
			av /= void
		do
			old_state.assign (bounding_object, velocity, angular_velocity)
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
	
	color : INTEGER -- the color of the ball
	number: INTEGER -- the number of the ball, 0 is the white ball
	owner : LINKED_LIST[Q_PLAYER] -- the owners of the ball, null if no owner yet specified, usually the list has only one owner

	bounding_object: Q_BOUNDING_CIRCLE
		
	velocity: Q_VECTOR_2D
			-- Velocity of ball
			
	angular_velocity: Q_VECTOR_3D
			-- Angular velocity of ball
	
	old_state: Q_PHYS_STATE_BALL
	
	typeid: INTEGER is 1
			-- Type id for collision response
	
	set_mu_sf (mu: DOUBLE) is
			-- Set sliding friction constant
		do
			mu_sf := mu
		end
		
	set_mu_rf (mu: DOUBLE) is
			-- Set sliding friction constant
		do
			mu_rf := mu
		end
	
	set_mass (m: DOUBLE) is
			-- Set sliding friction constant
		do
			mass := m
		end
		
	-- START DEBUG --
	set_ball0_track (track: LINKED_LIST[Q_VECTOR_2D]) is
		do
			ball0_track := track
		end
		
	ball0_track: LINKED_LIST[Q_VECTOR_2D]
	-- END DEBUG --
	
feature {NONE}-- implementation
	
	physics: Q_PHYSICS is
			-- Physics helper functions
		once
			Result := create {Q_PHYSICS}
		end
	
	radvec: Q_VECTOR_3D is
			-- Radius vector
		do
			result := create {Q_VECTOR_3D}.make (0, -1 * radius, 0)
		end
	
	mass: DOUBLE -- is 0.2
	
	theta: DOUBLE is
			-- Theta would actually be a matrix.
			-- But since the matrix is the identify matrix for a ball it can
			-- be reduced to a real number
		do
			result := 2/5 * mass * radius * radius
		end
	
--	mu_sf: DOUBLE is 0.5
	mu_sf: DOUBLE
			-- Sliding friction constant (Gleitreibung)
			
--	mu_rf: DOUBLE is 2.5
	mu_rf: DOUBLE
			-- Rolling friction constant (Rollreibung)
	
	sf_const: DOUBLE is
			-- Constant part of sliding friction: mu_sf * fn
		do
			Result := mu_sf * physics.force_normal_val (mass)
		end
		
	rf_const: DOUBLE is
			-- Constant part of rolling friction: mu_rf * fn
		do
			Result := mu_rf * physics.force_normal_val (mass)
		end
		
	

end -- class Q_BALL
