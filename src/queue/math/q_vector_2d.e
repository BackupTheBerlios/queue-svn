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
	description: "2 dimensional vector"
	author: "Andreas Kaegi"

class
	Q_VECTOR_2D

inherit
	VECTOR_2D
		redefine
			default_create,
			is_equal
--			out,
--			is_equal
--		select
--			out
		end
	
	DEBUG_OUTPUT
		undefine
			default_create,
			out,
			is_equal
		end


create
	default_create,
	make, 
	make_from_other,
	make_moved, 
	make_distance
	
feature {NONE} -- create

	default_create is
			-- Make vector with initial position zero.
		do
			make (0, 0)
		end

	
feature -- interface

	debug_output: STRING is
		do
			result := "d: (" + x.out + ", " + y.out + ") l: " + length.out
		end
		
	set_x_y(x_:DOUBLE;y_:DOUBLE) is
			-- set x and y
		do
			set_x(x_)
			set_y(y_)
		end
		
	projection (x_: like Current): Q_VECTOR_2D is
			-- Projection of 'other' onto 'Current' vector
		local
			len: DOUBLE
		do
			-- Py*x = 1 / |y|^2 * y*y'*x	(y = Current)
			-- y/|y| gives us the direction
			-- y'*x / |y| gives us the length
			
			len := (1 / length_square) * Current.scalar_product (x_)
			
			result := Current * len
		end
	
	is_null: BOOLEAN is
			-- Is 'Current' equal to (0, 0)?
		do
			Result := (x = 0) and (y = 0)
		end
	
	is_equal (other: like Current): BOOLEAN is
			-- Is 'other' equal to 'Current'?
		do
			Result := (x = other.x) and (y = other.y)
		end
		
	unit_vector: Q_VECTOR_2D is
			-- v / ||v||
		do
			if is_null then
				Result := create {Q_VECTOR_2D}.make (0, 0)
			else
				Result := Current / length
			end
		end
		
	length_square: DOUBLE is
			-- Square length of vector
		do
			result := x*x + y*y
		end
		
	distance_square (other: like Current): DOUBLE is
			-- Square distance to 'other'
		require
			other /= Void
		do
			result := (other.x - x)^2 + (other.y - y)^2
		end	

end -- class Q_VECTOR_2D

