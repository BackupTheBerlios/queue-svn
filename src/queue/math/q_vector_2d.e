indexing
	description: "2 dimensional vector"
	author: "Andreas Kaegi"

class
	Q_VECTOR_2D

inherit
	VECTOR_2D
		redefine
			default_create
--		select
--			out
		end
	
	DEBUG_OUTPUT
		undefine
			default_create,
			out
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
	
	is_null: BOOLEAN is
			-- Is 'Current' equals to (0, 0)?
		do
			Result := (x = 0) and (y = 0)
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

