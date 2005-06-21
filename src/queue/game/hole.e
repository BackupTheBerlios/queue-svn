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
	description: "Objects that represent a hole with balls"
	author: "Severin Hacker"

class
	Q_HOLE

inherit
	Q_OBJECT
	redefine
		bounding_object
	end
	
create
	make, make_from_points
	
feature 
	
	make (position_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- creation procedure
		do
			bounding_object := create {Q_BOUNDING_CIRCLE}.make (position_, Void, radius_)
			
			create caught_balls.make (1, 5)
		end
		
	make_from_points (positions_: ARRAY[Q_VECTOR_2D]) is
			-- create a hole from 3 points
		require
			positions_ /= void
		local
			index_ : INTEGER
			p: Q_VECTOR_2D
		do
			bounding_object := create {Q_BOUNDING_CIRCLE}.make_empty
			create caught_balls.make (1, 5)
			
			create p.default_create
			from
				index_ := positions_.lower
			until
				index_ > positions_.upper
			loop
				p.add (positions_.item (index_))
				
				index_ := index_ + 1
			end
			
			p.scale (1.0 / index_)

			set_position (p)
			set_radius ((p - positions_.item (0)).length)

		end
	
	position: Q_VECTOR_2D is
			-- Position of the hole
		do
			Result := bounding_object.center
		end
		
	radius: DOUBLE is
			-- the size of the hole
		do
			Result := bounding_object.radius
		end
		
	caught_balls: ARRAY[Q_BALL]
			-- the balls that fell in this hole

	bounding_object: Q_BOUNDING_CIRCLE
	
	typeid: INTEGER is 3
			-- Type id for collision response

feature -- implementation

	set_radius(r: DOUBLE) is
		do
			bounding_object.set_radius(r)
		end
		
	set_position(p: Q_VECTOR_2D) is
		do
			bounding_object.set_center(p)
		end

invariant
	position_set : position /= Void
	
end -- class HOLE
