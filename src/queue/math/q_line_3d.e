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
	description: "a 3 dimensional line"
	author: "Benjamin Sigg"

class
	Q_LINE_3D

creation
	make_empty, make, make_vectorized

feature{NONE}
	make_empty is
		do
			make( 0, 0, 0, 1, 0, 0 )
		end
		
	make( px_, py_, pz_, dx_, dy_, dz_ : DOUBLE ) is
		do
			create position.make( px_, py_, pz_ )
			create direction.make( dx_, dy_, dz_ )
		end
		
	make_vectorized( position_, direction_ : Q_VECTOR_3D ) is
		require
			position_ /= void
			direction_ /= void
		do
			position := position_
			direction := direction_
		end
		

feature
	position, direction : Q_VECTOR_3D
	
feature -- geometric
	cut_distance_within_range( plane_ : Q_PLANE; min_, max_ : DOUBLE ) : BOOLEAN is
			-- True if the distanc of the point cutting the plane is
			-- in between min_ and max_, where the length of
			-- direction is one unit
		local
			distance_ : DOUBLE
		do
			if plane_.direction_parallel( direction ) then
				result := false
			else
				distance_ := plane_.cut_distance( current )
				result := min_ <= distance_ and distance_ <= max_
			end
		end

end -- class Q_LINE_3D
