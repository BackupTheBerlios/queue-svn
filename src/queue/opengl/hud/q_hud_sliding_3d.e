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
	description: "A container witch slides the 0-point of its coordinate-system in 3d-space"
	author: "Benjamin Sigg"

class
	Q_HUD_SLIDING_3D

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
			
			source := create {Q_VECTOR_3D}.make( 0, 0, 0 )
			destination := create {Q_VECTOR_3D}.make( 0, 0, 0 )
			position := create {Q_VECTOR_3D}.make( 0, 0, 0 )
			duration := 1500
		end
		
feature{NONE}
	source, destination : Q_VECTOR_3D
	position : Q_VECTOR_3D

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
		local
			vector_ : Q_VECTOR_3D
			max_ : DOUBLE
		do
			precursor( open_gl )
			
			-- change position
			
			vector_ := destination - position
			max_ := vector_.length			
			
			if max_ /= 0 then
				vector_.scaled( ( open_gl.time.delta_time_millis / duration / max_ ).min( 1 ) )
				position.add( vector_ )
			end
		end
		
	enqueue( queue_: Q_HUD_QUEUE ) is
		local
			component_ : Q_HUD_COMPONENT
			tx_, ty_, tz_ : DOUBLE
		do
			queue_.insert( current )
			queue_.push_matrix
			
			tx_ := source.x
			ty_ := source.y
			tz_ := source.z
	
			if destination.x /= source.x then
				tx_ := tx_ + math.smooth( (position.x-source.x)/(destination.x-source.x) )*(destination.x-source.x)
			end
			
			if destination.y /= source.y then
				ty_ := ty_ + math.smooth( (position.y-source.y)/(destination.y-source.y) )*(destination.y-source.y)
			end
			
			if destination.z /= source.z then
				tz_ := tz_ + math.smooth( (position.z-source.z)/(destination.z-source.z) )*(destination.z-source.z)
			end
			
			queue_.translate( -tx_, -ty_, -tz_ )
			
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
		
		
	move_to( location_ : Q_VECTOR_3D ) is
			-- Moves this container so that the line at "location_" is attop
		require
			location_ /= void
		do
			create source.make_from( position )
			create destination.make_from ( location_ )
		end
	
	set_position( location_ : Q_VECTOR_3D ) is
			-- Changes the actual position immidiatelly to the given location
			-- No animation will be shown
		require
			location_ /= void
		do
			create position.make_from ( location_ )
			create source.make_from ( location_ )
			create destination.make_from ( location_ )
		end
		
		
	current_position : Q_VECTOR_3D is
		do
			result := position
		end
		
		
	destination_position : Q_VECTOR_3D is
			-- Where the current animation will stop
		do
			result := destination
		end

end -- class Q_HUD_SLIDING_3D
