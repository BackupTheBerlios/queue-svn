indexing
	description: "Mathematical functions relatet only to 3d-objects"
	author: "Benjamin Sigg"

class
	Q_GEOM_3D
inherit
	Q_MATH
	
feature -- Cuting
	cut_plane_line( plane_position_, plane_direction_a_, plane_direction_b_, line_position_, line_direction_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		local
			sizes_ : ARRAY[ DOUBLE ]
		do
			sizes_ := cut_plane_line_sizes( plane_position_, plane_direction_a_, plane_direction_b_, line_position_, line_direction_ )
			
			if sizes_ /= void then
				result := line_direction_.scale( sizes_.item( 3 ))
				result.add( line_position_ )
			else
				result := void
			end
		end
	

	cut_plane_line_sizes( plane_position_, plane_direction_a_, plane_direction_b_, line_position_, line_direction_ : Q_VECTOR_3D ) : ARRAY[ DOUBLE ] is
			-- Calculates the cut of a plane and a line.
			-- Returns an array, following holds on this array:
			-- plane_psotion_ + result.item(1)*plane_direction_a_ + result.item(2)*plane_direction_b_ = line_position + result.item(3)*line_direction_
			-- If there is no such solution, a void-array is returned
		local
			system_ : ARRAY2[ DOUBLE ]
			b_ : ARRAY[ DOUBLE ]
		do
			create system_.make( 3, 3 )
			create b_.make( 1, 3 )
			
			system_.put( plane_direction_a_.x, 1, 1 )
			system_.put( plane_direction_a_.y, 2, 1 )
			system_.put( plane_direction_a_.z, 3, 1 )
			
			system_.put( plane_direction_b_.x, 1, 2 )
			system_.put( plane_direction_b_.y, 2, 2 )
			system_.put( plane_direction_b_.z, 3, 2 )
			
			system_.put( -line_direction_.x, 1, 3 )
			system_.put( -line_direction_.y, 2, 3 )
			system_.put( -line_direction_.z, 3, 3 )
			
			b_.put( line_position_.x - plane_position_.x, 1 )
			b_.put( line_position_.y - plane_position_.y, 2 )
			b_.put( line_position_.z - plane_position_.z, 3 )
			
			result := gauss_changing( system_, b_ )
		end
		

end -- class Q_GEOM_3D
