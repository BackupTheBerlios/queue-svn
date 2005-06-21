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
	description: "Bounding box: circle"
	author: "Andreas Kaegi"

class
	Q_BOUNDING_CIRCLE

inherit
	Q_BOUNDING_OBJECT
	redefine
		copy
	end

create
	make, 
	make_empty
	
feature -- create

	make_empty is
			-- Make empty bounding circle.
		do
			create center.default_create
		end
		
	make (center_, center_old_: Q_VECTOR_2D; radius_: DOUBLE) is
			-- Make bounding circle.
		require
			center_ /= Void
			center_old_ /= Void
			radius_ >= 0
		do
			center := center_
			center_old := center_old_
			radius := radius_
		end
		
	copy (other: like Current) is
		do
			center.make_from_other (other.center)
			radius := other.radius
			center_old := other.center_old
		end
		

feature -- interface

	set_center (c: Q_VECTOR_2D) is
			-- Set center to 'c'.
		require
			c /= Void
		do
			center := c
		end
	
	set_center_old (c: Q_VECTOR_2D) is
			-- Set old center to 'c'.
		require
			c /= Void
		do
			center_old := c
		end
		
	set_radius (r: DOUBLE) is
			-- Set radius to 'r'.
		require
			r >= 0
		do
			radius := r
		end

	center: Q_VECTOR_2D
			-- Center of bounding circle
	
	center_old: Q_VECTOR_2D
			-- Old center of bounding circle
			
	radius: DOUBLE
			-- Radius of bounding circle
	
	typeid: INTEGER is 1
			-- Type id for collision detection

end -- class Q_BOUNDING_CIRCLE
