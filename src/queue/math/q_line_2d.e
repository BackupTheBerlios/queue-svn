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
			set_direction
		end


feature -- interface

	intersect (e1, e2: Q_VECTOR_2D): BOOLEAN is
			-- Do current line and line (e1,e2) intersect?
		local
			other_direction: Q_VECTOR_2D
			x_dist, y_dist, param, denom: DOUBLE
			x_inter, y_inter: DOUBLE
		do
			other_direction := e2 - e1
			
			-- Algorithm as explained under http://astronomy.swin.edu.au/~pbourke/geometry/lineline2d/
			x_dist := edge1.x - e1.x
			y_dist := edge1.y - e1.y
			denom := other_direction.y * direction.x - other_direction.x * direction.y
			
			if denom = 0 then
				result := False
			else
				param := (other_direction.x * y_dist - other_direction.y * x_dist) / denom
				-- End algo
				
				x_inter := edge1.x + direction.x * param
				y_inter := edge1.y + direction.y * param
				
				result := point_on_line (x_inter, y_inter, edge1, edge2) and point_on_line (x_inter, y_inter, e1, e2)
			end
		end
		
	distance_vector (p: Q_VECTOR_2D): Q_VECTOR_2D is
			-- Distance vector of 'p' to this line (with direction to p)
		require
			p /= void
		local
			e1e2, e1p, proj: Q_VECTOR_2D
		do
			e1e2 := edge2 - edge1
			e1p := p - edge1
			
			proj := e1e2.projection (e1p)
			
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
			set_direction
		end
		
	set_edge2 (e2: Q_VECTOR_2D) is
			-- Set edge2.
		require
			edge2 /= void
		do
			edge2 := e2
			set_direction
		end	

	length: DOUBLE is
			-- Length of line
		do
			result := (edge2 - edge1).length
		end
		
	length_square: DOUBLE is
			-- Square length of line
		do
			result := (edge2 - edge1).length_square
		end
		
		
	edge1, edge2: Q_VECTOR_2D
			-- Edges 1 & 2
			
feature {NONE} -- implementation

	set_direction is
			-- Set direction.
		do
			direction := edge2 - edge1
		end
		
	direction: Q_VECTOR_2D
	
	point_on_line (x,y: DOUBLE; e1, e2: Q_VECTOR_2D): BOOLEAN is
			-- Is point (x,y) on line (e1,e2)?
		do
			result :=
				e1.x.min (e2.x) <= x and
				e1.y.min (e2.y) <= y and
				x <= e1.x.max (e2.x) and
				y <= e1.y.max (e2.y)
		end
		
--	math: DOUBLE_MATH is
--		once
--			create result
--		end
		
	
end -- class Q_LINE_2D
