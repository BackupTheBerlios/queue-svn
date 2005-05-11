indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_LINE_2D
	
create
	make
	
feature -- interface

	make(edge1, edge2: Q_VECTOR_2D) is
			-- Create new line with edges e1 and e2
		do
			e1 := edge1
			e2 := edge2
			
		end
		
	distance_vector(p: Q_VECTOR_2D): DOUBLE is
			-- Calculate distance between this line and a vector (point)
		local
			e1e2, e1p, projection: Q_VECTOR_2D
			d: DOUBLE
		do
			-- We first calculate the projection of e1p (x) onto e1e2 (y)
			-- Py*x = 1 / |y|^2 * y*y'*x
			-- y/|y| gives us the direction
			-- y'*x / |y| gives us the length
			
			e1e2 := e2 - e1
			e1p := p - e1
		
			d := 1 / e1e2.scalar_product(e1e2)
			d := d * e1e2.scalar_product(e1p)
			
			projection := e1e2 * d
			
			-- Now let's calculate the difference vector of proj - e1p and take its length
			Result := (e1p - projection).length;

		end
		
feature {NONE} -- implementation

	e1, e2: Q_VECTOR_2D

end -- class Q_LINE_2D
