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
	description: "A 3dimensional plane"
	author: "Benjamin Sigg"

class
	Q_PLANE
	
creation
	make_empty, make, make_normal, make_vectorized

feature -- Creation
	make_empty is
		do
			set( 0, 1, 0, 0 )
		end
		
	make( a_, b_, c_, d_ : DOUBLE ) is
		do
			set( a_, b_, c_, d_ )
		end
	
	make_normal( position_, normal_ : Q_VECTOR_3D ) is
		do
			set_a( normal_.x )
			set_b( normal_.y )
			set_c( normal_.z )
			set_d( -a*position_.x - b*position_.y - c*position_.z )
		end
		
	make_vectorized( position_, direction_a_, direction_b_ : Q_VECTOR_3D ) is
		do
			make_normal( position_, direction_a_.cross( direction_b_ ))
		end
		
	
feature -- values
	a, b, c, d : DOUBLE
		-- The values descriping the plane.
		-- For any point in the plane, "a*x + b*y + c*z + d = 0" is true
	
	set_a( a_ : DOUBLE ) is
		do
			a := a_
		end
		
	set_b( b_ : DOUBLE ) is
		do
			b := b_
		end
		
	set_c( c_ : DOUBLE ) is
		do
			c := c_
		end
		
	set_d( d_ : DOUBLE ) is
		do
			d := d_
		end

	set( a_, b_, c_, d_ : DOUBLE ) is
		do
			a := a_
			b := b_
			c := c_
			d := d_
		end
	
	normal : Q_VECTOR_3D is
		do
			create result.make( a, b, c )
		end
	
feature -- Geometric
	equals_toleranced( other_ : Q_PLANE; tolerance_ : DOUBLE ) : BOOLEAN is
			-- returns true, if the other plane is parallel to this plane, and
			-- at the same position in space. The tolerance_-value tells, how
			-- great the relative error is allowed to be
		local
			ratio_ : DOUBLE
		do
			ratio_ := 1
			
			if a /= 0 then
				ratio_ := other_.a / a
			elseif b /= 0 then
				ratio_ := other_.b / b
			elseif c /= 0 then
				ratio_ := other_.c / c
			elseif d /= 0 then
				ratio_ := other_.d / d
			end
			
			result := 
			 	( a * ratio_ - other_.a ) <= tolerance_ and
			 	( b * ratio_ - other_.b ) <= tolerance_ and
			 	( c * ratio_ - other_.c ) <= tolerance_ and
			 	( d * ratio_ - other_.d ) <= tolerance_ 
		end
		
	direction_parallel( direction_ : Q_VECTOR_3D ) : BOOLEAN is
		do
			result := direction_parallel_toleranced( direction_, 0 )
		end
		
		
	direction_parallel_toleranced( direction_ : Q_VECTOR_3D; tolerance_ : DOUBLE ) : BOOLEAN is
			-- True if the given direction is parallel to this plane. The tolerance is the
			-- relative failur of the calculation respective to direction_'s length
		do
			result :=
				((direction_.x /= 0) or (direction_.y /= 0) or (direction_.z /= 0) ) and then
				(a*direction_.x + b*direction_.y + c*direction_.z <= tolerance_*direction_.length)
		end
		
		
	cut_distance( line_ : Q_LINE_3D ) : DOUBLE is
			-- "result*direction_+positon_" gives the point in witch this
			-- plane and the line "position, direction" cuts
		require
			not_parellel : not direction_parallel( line_.direction )
		do
			-- a(p.x + r*d.x) + b(p.y + r*d.y) + c(p.z + r*d.z) + d = 0
			result := (-d - a*line_.position.x - b*line_.position.y - c*line_.position.z) / 
				(a*line_.direction.x + b*line_.direction.y + c*line_.direction.z)
		end
	
	cut( line_ : Q_LINE_3D ) : Q_VECTOR_3D is
			-- The point in witch plane and line cuts eatch other
		local
			length_ : DOUBLE
		do
			length_ := cut_distance( line_ )
			
			create result.make_from( line_.direction )
			result.scaled( length_ )
			result.add( line_.position )
		end
		
		
	point_distance( point_ : Q_VECTOR_3D ) : DOUBLE is
			-- The distanc of a point to this plane. The value is positiv or negatv
			-- respective to the side of the plane, the point is.
		do
			result := (a*point_.x + b*point_.y + c*point_.z + d) / (math.sqrt( a*a + b*b + c*c ))
		end
	
	in_front( point_ : Q_VECTOR_3D ) : BOOLEAN is
			-- true if the given point is in front of the plane
		do
			result := (a*point_.x + b*point_.y + c*point_.z + d) >= 0
		end
		
feature {NONE} -- Math
	math : DOUBLE_MATH is
		once
			create result
		end
end -- class Q_PLANE
