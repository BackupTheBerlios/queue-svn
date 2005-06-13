indexing
	description: "A container that makes a looping with its components"
	author: "Benjamin Sigg"

class
	Q_HUD_LOOPING

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
	
feature{NONE} -- looping
	angle : DOUBLE

feature -- looping
	looping is
			-- adds another looping, if, and only if, more than 90% of
			-- the last looping is over
		do
			if angle > -0.1 then
				angle := angle - 1
			end
		end
		
	force_looping is
			-- adds a looping
		do
			angle := angle - 1
		end
		
	stop is
			-- immediatelly stops the loopings
		do
			angle := 0
		end
		
feature -- draw
	visible : BOOLEAN is
		do
			result := false
		end
		
	draw( open_gl: Q_GL_DRAWABLE ) is
		do
			precursor( open_gl )
			if angle < 0 then
				angle := angle + open_gl.time.delta_time_millis / duration
				if angle > 0 then
					angle := 0
				end
			end
		end
		

	enqueue( queue_: Q_HUD_QUEUE ) is
		do
			if angle = 0 then
				precursor( queue_ )
			else
				queue_.push_matrix
				queue_.rotate_around( axis.x, axis.y, axis.z, 
					math.smooth( -(angle - angle.ceiling ) ) * 2 * math.pi,
					(width/2), (height/2), 0 )
				precursor( queue_ )
				queue_.pop_matrix
			end
		end
		
		
feature{NONE} -- math
	math : Q_MATH is
		once
			create result
		end
		
	
end -- class Q_HUD_LOOPING
