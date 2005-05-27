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
