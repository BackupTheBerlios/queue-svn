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
	description: "Some methods of mathematical structures"
	author: "Benjamin Sigg"

class
	Q_MATH
	
inherit
	DOUBLE_MATH
	export
		{ANY} pi, sqrt2, euler
	end
	
feature -- math
	smooth( x_ : DOUBLE ) : DOUBLE is
			-- transforms a value between 0 and 1 into a new value between 0 and 1 on 
			-- a curve with a differential of 0 at x=0 and x=1
		do
			result := 3*x_*x_ - 2*x_*x_*x_
		end
		
	smooth_over( x_ : DOUBLE ) : DOUBLE is
			-- 
		do
			result := 0.1 + smooth( x_ )
		end
		
		
	
feature -- gauss
	gauss_changing( system_ : ARRAY2[ DOUBLE ]; b_ : ARRAY[ DOUBLE ] ) : ARRAY[ DOUBLE ] is
			-- Solves the system "system_*result = b_"
			-- This method might change the contents of system_ and of b_
		require
			width_same : system_.width = b_.count
			quadratic : system_.width = system_.height
			standard_indices : b_.lower = 1
		do
			if gauss_triangle( system_, b_ ) then
				result := gauss_solve( system_, b_ )
			end
		ensure
			result = void or else system_.height = result.count
		end

	gauss_solve( system_ : ARRAY2[ DOUBLE ]; b_ : ARRAY[ DOUBLE ] ) : ARRAY[ DOUBLE ] is
			-- Solves a system of equations, "system_*result = b_"
			-- The System must have a triangular form (see gauss_triangle)
		local
			row_, index_ : INTEGER
			sum_ : DOUBLE
		do
			from
				create result.make( 1, b_.count )
				row_ := b_.count
			until
				row_ < 1
			loop
				
				from
					index_ := row_+1
					sum_ := 0
				until
					index_ > b_.count
				loop
					sum_ := sum_ + result.item( index_ ) * system_.item( row_, index_ )
					index_ := index_ + 1
				end
				
				sum_ := b_.item( row_ ) - sum_
				result.put( sum_ / system_.item( row_, row_ ), row_ )
				
				row_ := row_ - 1
			end
		end

	gauss_triangle( system_ : ARRAY2[ DOUBLE ]; b_ : ARRAY[ DOUBLE ] ) : BOOLEAN is
		-- Changes the given equationsystem so that the matrix is a upper right triangular-matrix
		local
			error_ : BOOLEAN
			index_, pivot_ : INTEGER
		do
			from
				error_ := false
				index_ := 1
			until
				error_ or index_ >= system_.height
			loop
				pivot_ := gauss_pivot( system_, index_ )
				if pivot_ < 0 then
					error_ := true
				else
					if pivot_ /= index_ then
						gauss_swap( system_, b_, index_, pivot_ )
					end
					
					gauss_sub( system_, b_, index_ )
					index_ := index_ + 1
				end
			end
			
			result := not error_
		end
		
feature{NONE} -- help gauss

	gauss_sub( system_ : ARRAY2[ DOUBLE ]; b_ : ARRAY[ DOUBLE ]; pivot_ : INTEGER ) is
		local
			index_ : INTEGER
		do
			from
				index_ := pivot_+1
			until
				index_ > system_.height
			loop
				gauss_scaled_sub( system_, b_, pivot_, index_, 
					system_.item( index_, pivot_ ) / system_.item( pivot_, pivot_ ))
				
				index_ := index_ + 1
			end
		end
		
	gauss_scaled_sub( system_ : ARRAY2[ DOUBLE ]; b_ : ARRAY[ DOUBLE ]; src_, dst_ : INTEGER; scale_ : DOUBLE ) is
			-- writes "dst - scale*src" into dst, beginning at "src/src"
		local
			index_ : INTEGER
		do
			from
				index_ := src_
			until
				index_ > system_.width
			loop
				system_.put( 
					system_.item( dst_, index_ ) - 
					system_.item( src_, index_ ) * scale_, 
					dst_, index_ )
				
				index_ := index_ + 1
			end
			
			b_.put( b_.item( dst_ ) - b_.item( src_ ) * scale_, dst_ )
		end
		

	gauss_swap( system_ : ARRAY2[ DOUBLE ]; b_ : ARRAY[ DOUBLE ]; x_, y_ : INTEGER ) is
		local
			index_ : INTEGER
			temp_ : DOUBLE
		do
			from
				index_ := 1
			until
				index_ > system_.width
			loop
				temp_ := system_.item( x_, index_ )
				system_.put( system_.item( y_, index_ ), x_, index_ )
				system_.put( temp_, y_, index_ )
				
				index_ := index_ + 1
			end
			
			temp_ := b_.item( x_ )
			b_.put( b_.item( y_ ), x_ )
			b_.put( temp_, y_ )
		end
		
	gauss_pivot( system_ : ARRAY2[ DOUBLE ]; column_ : INTEGER ) : INTEGER is
		local
			index_, best_index_ : INTEGER
			best_ : DOUBLE
		do
			from
				index_ := column_
				best_index_ := index_
				best_ := system_.item( index_, index_ )
			until
				index_ > system_.height
			loop
				if best_ < system_.item ( index_, column_ ).abs then
					best_ := system_.item ( index_, column_ ).abs
					best_index_ := index_
				end
				
				index_ := index_ + 1
			end
			
			if best_ = 0 then
				result := -1
			else
				result := best_index_
			end
		end

end -- class Q_MATH
