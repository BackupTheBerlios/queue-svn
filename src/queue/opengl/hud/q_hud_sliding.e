indexing
	description: "A container that slides its children"
	author: "Benjamin Sigg"

class
	Q_HUD_SLIDING

inherit
	Q_HUD_CONTAINER
	redefine
		make, draw, enqueue
	end
	
creation
	make
	
feature{NONE} -- creation
	make is
		do
			precursor
			create children.make( 10 )
			
			source := 0
			destination := 0
			position := 0
			duration := 1500
		end
		
feature{NONE}
	source, destination : DOUBLE
	position : DOUBLE

	math : Q_MATH is
		once
			create result
		end

feature -- fields
	duration : DOUBLE
	
	set_duration( duration_ : DOUBLE ) is
		require
			duration >= 0
		do
			duration := duration_
		end
		
		
feature
	draw( open_gl: Q_GL_DRAWABLE ) is
		do
			precursor( open_gl )
			
			-- change position
			if position < destination then
				position := position + open_gl.time.delta_time_millis / duration
				
				if position > destination then
					position := destination
				end
			else
				position := position - open_gl.time.delta_time_millis / duration
				
				if position < destination then
					position := destination
				end
				
			end
		end
		
	enqueue( queue_: Q_HUD_QUEUE ) is
		local
			component_ : Q_HUD_COMPONENT
		do
			queue_.insert( current )
			queue_.push_matrix
			
			if destination /= source then
				queue_.translate( 0, -(source + math.smooth( (position-source)/(destination-source) )*(destination-source)), 0 )
			else
				queue_.translate( 0, -source, 0 )
			end
			
			from children.start until children.after loop
				component_ := children.item
				
				queue_.translate( component_.x, component_.y, 0 )
				component_.enqueue( queue_ )
				queue_.translate( -component_.x, -component_.y, 0 )
				
				children.forth
			end
			
			queue_.pop_matrix
		end
		
		
	children_count : INTEGER is
			-- 
		do
			result := children.count
		end
		
		
	move_to( location_ : DOUBLE ) is
			-- Moves this container so that the line at "location_" is attop
		do
			source := position
			destination := location_
		end
		
	current_location : DOUBLE is
		do
			result := position
		end
		
		
	location : DOUBLE is
			-- The currently top-side of the component
		do
			result := destination
		end
		
		

end -- class Q_HUD_SLIDING
