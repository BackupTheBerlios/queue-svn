indexing
	description: "Physical line representation"
	author: "Andreas Kaegi"

class
	Q_LINE_2D
	
create
	make,
	make_empty
	
feature {NONE} -- create

	make_empty is
			-- Create new empty line (without edges).
		do
		end
		
	make (edge1_, edge2_: Q_VECTOR_2D) is
			-- Create new line with edges e1 and e2.
		require
			edge1 /= void
			edge2 /= void
		do
			edge1 := edge1_
			edge2 := edge2_
			
		end


feature -- interface

	distance_vector (p: Q_VECTOR_2D): Q_VECTOR_2D is
			-- Distance vector of 'p' to this line (with direction to p)
		require
			p /= void
		local
			e1e2, e1p, proj: Q_VECTOR_2D
			d: DOUBLE
		do
			-- We calculate the projection of e1p (x) onto e1e2 (y)
			-- Py*x = 1 / |y|^2 * y*y'*x
			-- y/|y| gives us the direction
			-- y'*x / |y| gives us the length
			
			e1e2 := edge2 - edge1
			e1p := p - edge1
		
			d := 1 / e1e2.scalar_product(e1e2)
			d := d * e1e2.scalar_product(e1p)
			
			proj := e1e2 * d
			
			result := e1p - proj
		end
		
	distance (p: Q_VECTOR_2D): DOUBLE is
			-- Distance between this line and a vector (point)
		require
			p /= void
		do
			-- Now let's calculate the difference vector of proj - e1p and take its length
			result := distance_vector (p).length
		end
		
	set_edge1 (e1: Q_VECTOR_2D) is
			-- Set edge1.
		require
			edge1 /= void
		do
			edge1 := e1
		end
		
	set_edge2 (e2: Q_VECTOR_2D) is
			-- Set edge2.
		require
			edge2 /= void
		do
			edge2 := e2
		end	

	edge1, edge2: Q_VECTOR_2D
			-- Edges 1 & 2

end -- class Q_LINE_2D
