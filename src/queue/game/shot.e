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
	description: "Objects that represent a physical shot with direction and strength"
	author: "Severin Hacker"

class
	Q_SHOT
	
create
	make,
	make_empty
	
feature -- Interface

	make (ball: Q_BALL; dir: Q_VECTOR_2D) is
			-- create a shot with direction vector
		require
			ball /= Void
			dir /= Void
		do
			direction := dir
			hitball := ball
		end
		
	make_empty is
			-- create a default shot
		do
			
		end
		
	set_hitpoint (h: Q_VECTOR_3D) is
			-- Set hitpoint to h.
		require
			h /= Void
		do
			hitpoint := h
		end
	
	set_direction (direction_: Q_VECTOR_2D) is
			-- sets the new direction of the shot
		require
			direction_exist : direction /= Void
		do
			direction := direction_
		ensure
			direction = direction_
		end
	
	set_ball (ball: Q_BALL) is
			-- Set hitball to ball.
		require
			ball /= Void
		do
			hitball := ball
		end
		
	-- hit_plane : Q_PLANE
	
--	set_hit( point_ : Q_VECTOR_3D; plane_ : Q_PLANE ) is
--		do
--			hit_point := point_
--			hit_plane := plane_
--		end
--		
	
	-- hackers: commented out because strength = |direction| = length of direction vector
	--strength : REAL -- the strength of the shot
	
	
	
	-- hackers: commented out because strength = |direction| = length of direction vector
--	set_strength(strength_:REAL) is
--			-- sets the strength of the shot
--		require
--			strength_exist : strength /= Void
--			pos_strength: strength_ > 0
--		do
--			strength := strength_
--		ensure
--			strength = strength_
--		end
		
	direction: Q_VECTOR_2D
			-- Direction of the shot in (x,y) coordinates
	
	hitpoint: Q_VECTOR_3D
			-- Hit point of the queue on the ball surface
			
	hitball: Q_BALL
			-- Hit ball
			
feature {NONE} -- implementation

end -- class SHOT
