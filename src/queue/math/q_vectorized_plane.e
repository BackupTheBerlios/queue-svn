indexing
	description: "A plane descriped by 3 vectors"
	author: "Benjamin Sigg"

class
	Q_VECTORIZED_PLANE

creation
	make, make_vectorized

feature{NONE} -- creation
	make is
		do
			create position.make( 0, 0, 0 )
			create a.make( 1, 0, 0 )
			create b.make( 0, 0, 1 )
		end
	
	make_vectorized( position_, a_, b_ : Q_VECTOR_3D ) is
		require
			position_exists : position_ /= void
			a_not_void : a /= void
			b_not_void : b /= void
		do
			position := position_
			a := a_
			b := b_
		end
		
	
feature
	position, a, b : Q_VECTOR_3D
		-- position and two direction of this plane

feature -- geometric
	direction_parallel( direction_ : Q_VECTOR_3D ) : BOOLEAN is
		do
			result := direction_parallel_toleranced( direction_, 0 )
		end
		
	direction_parallel_toleranced( direction_ : Q_VECTOR_3D; tolerance_ : DOUBLE ) : BOOLEAN is
		do
			result := direction_.dot( normal ) <= direction_.length * tolerance_
		end
		
		
	normal : Q_VECTOR_3D is
		do
			result := a.cross ( b )
		end
		

	cut_line( line_ : Q_LINE_3D ) : Q_VECTOR_3D is
			-- Cuts a line with a plane
		local
			sizes_ : ARRAY[ DOUBLE ]
		do
			sizes_ := cut_line_sizes( line_ )
			
			if sizes_ /= void then
				result := line_.direction.scale( sizes_.item( 3 ))
				result.add( line_.position )
			else
				result := void
			end
		end

	cutting_inside( line_ : Q_LINE_3D; line_min_, line_max_ : DOUBLE ) : BOOLEAN is
			-- returns true if the line is cutting this plane in a point
			-- p = position + x*a + y*b and 0 <= x <= 1 and 0 <= y <= 1 and
			-- the line-direction-scale-factor is between line_min_, line_max_
		local
			size_ : ARRAY[ DOUBLE ]
		do
			size_ := cut_line_sizes( line_ )
			
			result := size_ /= void and then
				( size_.item( 1 ) >= 0 and size_.item( 1 ) <= 1 and
				  size_.item( 2 ) >= 0 and size_.item( 2 ) <= 1 and
				  size_.item( 3 ) >= line_min_ and size_.item( 3 ) <= line_max_ )
		end
	
	cut_line_sizes( line_ : Q_LINE_3D ) : ARRAY[ DOUBLE ] is
			-- Calculates the cut of a plane and a line.
			-- Returns an array, following holds on this array:
			-- position + result.item(1)*a + result.item(2)*b = line_position + result.item(3)*line_direction_
			-- If there is no such solution, a void-array is returned
		local
			system_ : ARRAY2[ DOUBLE ]
			b_ : ARRAY[ DOUBLE ]
		do
			create system_.make( 3, 3 )
			create b_.make( 1, 3 )
			
			system_.put( a.x, 1, 1 )
			system_.put( a.y, 2, 1 )
			system_.put( a.z, 3, 1 )
			
			system_.put( b.x, 1, 2 )
			system_.put( b.y, 2, 2 )
			system_.put( b.z, 3, 2 )
			
			system_.put( -line_.direction.x, 1, 3 )
			system_.put( -line_.direction.y, 2, 3 )
			system_.put( -line_.direction.z, 3, 3 )
			
			b_.put( line_.position.x - position.x, 1 )
			b_.put( line_.position.y - position.y, 2 )
			b_.put( line_.position.z - position.z, 3 )
			
			result := math.gauss_changing( system_, b_ )
		end	

	cutting_inside_plane( plane_ : Q_PLANE ) : BOOLEAN is
			-- true if one of the 4 lines capseling this plane
			-- cutts "in range" with plane_
		do
			result :=
				(create {Q_LINE_3D}.make_vectorized( position, a )).cut_distance_within_range( plane_, 0, 1 ) or
				(create {Q_LINE_3D}.make_vectorized( position, b )).cut_distance_within_range( plane_, 0, 1 ) or
				(create {Q_LINE_3D}.make_vectorized( position+b, a )).cut_distance_within_range( plane_, 0, 1 ) or
				(create {Q_LINE_3D}.make_vectorized( position+a, b )).cut_distance_within_range( plane_, 0, 1 )
		end
		

feature {NONE} -- math
	math : Q_MATH is
		once
			create result
		end
		

end -- class Q_VECTORIZED_PLANE
