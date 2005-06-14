indexing
	description: "Physical line representation"
	author: "Andreas Kaegi"

class
	Q_LINE_2D
	
inherit
	DOUBLE_MATH
	export
		{ANY} dabs
	end

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
	
	contains (a: Q_VECTOR_2D): BOOLEAN is
			-- Is point 'a' on line?
		do
			Result := contains_k (a, Void)
		end
		
	contains_k (a: Q_VECTOR_2D; k_tuple: TUPLE[DOUBLE, DOUBLE]): BOOLEAN is
			-- Is point 'a' on line?
			-- k_tuple contains factors kx and ky that denote the x/y-components of
			-- the length of vector (a - edge1)
		local
			e1e2: Q_VECTOR_2D
			ae1: Q_VECTOR_2D
			len: DOUBLE
			kx, ky: DOUBLE
		do
			result := True
			
			e1e2 := edge2 - edge1
			len := e1e2.length
			e1e2.normalize
			
			ae1 := a - edge1
			
			if is_eq (e1e2.x, 0) then
				kx := 0
			else
				kx := ae1.x / e1e2.x
			end
			
			if is_eq (e1e2.y, 0) then
				ky := 0
			else
				ky := ae1.y / e1e2.y
			end
			
			if kx = 0 then
				if is_eq (ae1.x, 0) then
					kx := ky
				else
					result := false
				end
			end
			
			if ky = 0 then
				if is_eq (ae1.y, 0) then
					ky := kx
				else
					result := false
				end
			end
			
			if not result or not is_eq (kx, ky) then
				result := False
			else
				if kx >= 0 and kx <= len then
					result := True
				else
					result := False
				end
			end
			
			if k_tuple /= Void then
				k_tuple.put_double (kx, 1)
				k_tuple.put_double (ky, 2)
			end
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

	length: DOUBLE is
			-- Length of line
		do
			result := (edge2 - edge1).length
		end
		
	edge1, edge2: Q_VECTOR_2D
			-- Edges 1 & 2
			
feature {NONE} -- implementation

	is_eq (x,y: DOUBLE): BOOLEAN is
			-- Are x and y the same?
		do
			if dabs (x-y) < 0.00001 then
				result := True
			else
				result := False
			end
		end

end -- class Q_LINE_2D
