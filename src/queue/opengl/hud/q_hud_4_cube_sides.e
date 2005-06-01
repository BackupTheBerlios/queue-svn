indexing
	description: "A Container witch has 4 sides. At every time, its possible to change witch side should be displayed"
	author: "Benjamin Sigg"

class
	Q_HUD_4_CUBE_SIDES
	
inherit
	Q_HUD_CONTAINER
	redefine
		make, set_width, set_height, enqueue, draw
	end
	
creation
	make
	
feature{NONE} -- creation
	make is
		local
			index_ : INTEGER
			side_ : Q_HUD_CONTAINER_3D
		do
			precursor
			
			create sides.make( 1, 4 )
			
			from
				index_ := 1
			until
				index_ > 4
			loop
				create side_.make
				side_.rotate_around( 0, 1, 0, math.pi * (index_-1) / 2, 0.5, 0.5, -0.5 )
				sides.put( side_, index_ )
				add( side_ )
				
				index_ := index_+1
			end
			
			destination := 0
			position := 0
			velocity := 5000
		end
		
feature{NONE} -- sides
	sides : ARRAY[ Q_HUD_CONTAINER_3D ]
	
	math : Q_MATH is
		once
			create result
		end
		
feature -- sides
	side( index_ : INTEGER ) : Q_HUD_CONTAINER is
			-- Returns a side of the cube
		do
			result := sides.item( index_ )
		end
		
	rotate_to( side_ : INTEGER ) is
			-- Rotates to a side
		require
			valid_target : side_ >= 1 and side_ <= 4
		do
			destination := (side_ - 1) / 4
		end
		
	rotated_to : INTEGER is
			-- The currently showed side
		do
			result := (destination * 4).rounded + 1
		end
		
		
		
feature{NONE} -- rotating
	destination : DOUBLE
		-- between 0 and 1
		
	position : DOUBLE
		-- between 0 and 1
		
	velocity : INTEGER
		-- how long for one rotation
		
	between( befor_, after_, test_ : DOUBLE; wrap_ : BOOLEAN ) : BOOLEAN is
		-- tests, if test is between befor and after. If wrap is true, test must
		-- be outside befor and after
		do
			if wrap_ then
				if befor_ > after_ then
					result := befor_ <= test_ or test_ <= after_
				else
					result := befor_ >= test_ or test_ >= after_
				end
			else			
				if befor_ < after_ then
					result := befor_ <= test_ and test_ <= after_
				else
					result := befor_ >= test_ and test_ >= after_
				end
			end
		end
	
	rotational_distance : DOUBLE is
			-- Value between 0 and 1, the "distance" of the position to the next possible destination
		do
			result := (position).abs.min( 
				(position-0.25).abs.min(
				(position-0.5).abs.min(
				(position-0.75).abs.min(
				(position-1.0).abs ))))
				
			result := result * 8
			result := math.smooth_over( result )
		end
		
	
feature
	draw( open_gl: Q_GL_DRAWABLE ) is
		local
			befor_ : DOUBLE
			wrap_ : BOOLEAN
		do
			precursor( open_gl )
			
			-- put position nearer to destination
			if position /= destination then
				befor_ := position
				wrap_ := false
				
				if destination > position then
					if destination - position > 0.5 then
						position := position - open_gl.delta_time_millis / velocity
						if position < 0 then
							position := position + 1
							wrap_ := true
						end
					else
						position := position + open_gl.delta_time_millis / velocity
						if position > 1 then
							position := position - 1
							wrap_ := true
						end
					end
				else
					if position - destination > 0.5 then
						position := position + open_gl.delta_time_millis / velocity
						if position > 1 then
							position := position - 1
							wrap_ := true
						end
					else
						position := position - open_gl.delta_time_millis / velocity
						if position < 0 then
							position := position + 1
							wrap_ := true
						end
					end
				end
			
				if between( befor_, position, destination, wrap_ ) then
					position := destination
				end
			end
		end
		

	enqueue( queue_: Q_HUD_QUEUE ) is
		do
			queue_.push_matrix
			
			queue_.translate( 0, 0, -rotational_distance )
			queue_.rotate_around( 0, 1, 0, math.pi*2*(1-position), 0.5, 0.5, -0.5 )

			precursor( queue_ )
			
			queue_.pop_matrix
		end
		

	set_width( width_ : DOUBLE ) is
		local
			index_ : INTEGER
		do
			precursor( width_ )
			
			from index_ := 1 until index_ > 4 loop
				sides.item( index_ ).set_width( width_ )
				index_ := index_ + 1
			end
		end
		
	set_height( height_ : DOUBLE ) is
		local
			index_ : INTEGER
		do
			precursor( height_ )
			
			from index_ := 1 until index_ > 4 loop
				sides.item( index_ ).set_height( height_ )
				index_ := index_ + 1
			end
		end		
		

end -- class Q_HUD_4_CUBE_SIDES
