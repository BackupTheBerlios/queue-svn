indexing
	description: "Rotates its children around an axis"
	author: "Benjamin Sigg"
	
class
	Q_HUD_ROTATING

inherit
	Q_HUD_CONTAINER

	redefine
		make, enqueue, draw, visible
	end
	
creation
	make
	
feature{NONE}
	make is
		do
			precursor
			
			create axis.make( 1, 0, 0 )
			duration := 1000
			
			set_enabled( false ) 
			set_focusable( false )
		end

feature -- values
	axis : Q_VECTOR_3D
		-- the axis, around witch the container rotates
		
	duration : INTEGER
		-- the time needed for one looping

	set_axis( axis_ : Q_VECTOR_3D ) is
		require
			axis_ /= void
		do
			axis := axis_
		end
		
	set_duration( duration_ : INTEGER ) is
		require
			duration_ > 0
		do
			duration := duration_
		end
	
feature{NONE} -- rotate
	source, destination : DOUBLE
	rotation : DOUBLE
	wait : BOOLEAN
	
	rotate( delta_ : INTEGER ) is
		local
			move_ : DOUBLE
		do
			move_ := (source - destination).abs
			if move_ > math.pi then
				move_ := 2*math.pi - move_
			end
				
			rotation := rotation + move_ * delta_ / math.pi / duration
			if rotation > 1 then
				rotation := 1
			end
		end
		

feature -- rotate
	angle : DOUBLE is
		local
			rotation_ : DOUBLE
		do
			rotation_ := math.smooth( rotation )
			if destination > source then
				if destination - source > math.pi then
					result := source - rotation_*( source + 2*math.pi - destination )
					if result < 0 then
						result := result + 2*math.pi
					end
				else
					result := rotation_ * destination + (1-rotation_)*source
				end
			else
				if source - destination > math.pi then
					result := source + rotation_ * (destination + 2*math.pi - source)
					if result > 2*math.pi then
						result := result - 2*math.pi
					end
				else
					result := rotation_ * destination + (1-rotation_)*source
				end
			end
		end
		

	set_angle( angle_ : DOUBLE ) is
			-- changes the angle in angle/2/pi*duration time into this new angle
		do
			source := angle
			destination := angle_
			rotation := 0
			wait := true
		end
		
	force_angle( angle_ : DOUBLE ) is
			-- changes the angle imediatelly to this new angle
		do
			source := angle_
			rotation := 1
			destination := angle_
		end
		
feature -- draw
	visible : BOOLEAN is
		do
			result := false
		end
		
	draw( open_gl: Q_GL_DRAWABLE ) is
		do
			precursor( open_gl )
			if wait then
				wait := false
			elseif rotation < 1 then
				rotate( open_gl.time.delta_time_millis )
			end
		end
		

	enqueue( queue_: Q_HUD_QUEUE ) is
		do
			if angle = 0 then
				precursor( queue_ )
			else
				queue_.push_matrix
				queue_.rotate_around( axis.x, axis.y, axis.z, 
					angle, (width/2), (height/2), 0 )					
				precursor( queue_ )
				queue_.pop_matrix
			end
		end
		
		
feature{NONE} -- math
	math : Q_MATH is
		once
			create result
		end

end -- class Q_HUD_ROTATING
