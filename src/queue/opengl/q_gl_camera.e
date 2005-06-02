indexing
	description: "A camera has different methods to set the view-direction"
	author: "Benjamin Sigg"


class
	Q_GL_CAMERA
	inherit
		Q_GL_TRANSFORM
		
feature -- transformation
	transform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_push_matrix
			
			ensure_matrix
			matrix.set( open_gl )
			
			end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_pop_matrix
		end

feature -- screen & model coordinate exchange
	transform_direction( vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		do
			ensure_matrix
			result := matrix.mul_vector_3( vector_ )
		end
		
	transform_position( vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		do
			ensure_matrix
			result := matrix.mul_vector_3_as_4( vector_ )
		end
		
	untransform_direction( vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		do
			ensure_inverse
			result := inverse.mul_vector_3( vector_ )
		end
		
	untransform_position( vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
		do
			ensure_inverse
			result := inverse.mul_vector_3_as_4( vector_ )
		end
		

feature{NONE} -- matrix
	matrix, inverse : Q_MATRIX_4X4
	
	ensure_matrix is
		local
			matrix_ : Q_MATRIX_4X4
		do
			if matrix = void then
				create matrix_.identity
				create matrix.identity
				
				matrix_.rotate( 1, 0, 0, -beta / 180 * pi )
				matrix := matrix.mul( matrix_ )
				
				matrix_.identity
				matrix_.rotate( 0, 1, 0, alpha / 180 * pi )
				matrix := matrix.mul( matrix_ )
				
				matrix_.identity
				matrix_.translate( -x, -y, -z )
				matrix := matrix.mul( matrix_ )
				
				inverse := void
			end
		end
		
	ensure_inverse is
		do
			if inverse = void then
				ensure_matrix
				inverse := matrix.inverted
			end
		end
		
		

feature -- view
	x : DOUBLE -- x positon
	y : DOUBLE -- y position
	z : DOUBLE -- z position
	alpha : DOUBLE -- angle horizontal
	beta : DOUBLE -- angle vertical

	set_x( x_ : DOUBLE ) is
		do
			if x /= x_ then
				x := x_
				matrix := void
			end
		end
		
	set_y( y_ : DOUBLE ) is
		do
			if y /= y_ then
				y := y_
				matrix := void
			end
		end
		
	set_z( z_ : DOUBLE ) is
		do
			if z /= z_ then
				z := z_
				matrix := void
			end
		end
		
	set_position( x_, y_, z_ : DOUBLE ) is
		do
			if x /= x_ or y /= y_ or z /= z_ then
				x := x_
				y := y_
				z := z_
				matrix := void
			end
		end
		
		
	set_alpha( alpha_ : DOUBLE ) is
		do
			if alpha /= alpha_ then
				if alpha_ > 360 then
					alpha := alpha_ - 360
				elseif alpha_ < 0 then
					alpha := alpha_ + 360
				else
					alpha := alpha_
				end
				
				matrix := void
			end
		end
	
	set_beta( beta_ : DOUBLE ) is
		do
			if beta_ /= beta then
				if beta_ > 360 then
					beta := beta_ - 360
				elseif beta_ < 0 then
					beta := beta_ + 360
				else
					beta := beta_
				end
				
				matrix := void
			end
		end
	
feature -- additional information
	view_direction : Q_VECTOR_3D is
			-- calculates the viewdirection of this camera
		do
			result := view_direction_by_angles( alpha, beta )
		end

	view_direction_by_angles( alpha_, beta_ : DOUBLE ) : Q_VECTOR_3D is
			-- calculates the direction someone views, if the given angles are used
		local
			rad_alpha_, sin_alpha_, cos_alpha_, rad_beta_, sin_beta_, cos_beta_ : DOUBLE
		do
			rad_alpha_ := alpha_ * pi / 180
			rad_beta_ := -beta_ * pi / 180
			
			sin_alpha_ := math.sine( rad_alpha_ )
			sin_beta_ := math.sine( rad_beta_ )
			
			cos_alpha_ := math.cosine( rad_alpha_ )
			cos_beta_ := math.cosine( rad_beta_ )
			
			create result.make(
				sin_alpha_ * cos_beta_, -sin_beta_, -cos_alpha_ * cos_beta_ )
		end

	to_right_vector: Q_VECTOR_3D is
			-- Calculates a vector pointing to the right of this camera
		do
			result := to_right_vector_by_angles( alpha )
		end
		

	to_right_vector_by_angles( alpha_ : DOUBLE ) : Q_VECTOR_3D is
			-- Calculates a vector pointing to the right direction by the given angle alpha
		local
			rad_, sin_, cos_ : DOUBLE
		do
			rad_ := (alpha + 90) /180 * pi
			sin_ := math.sine( rad_ )
			cos_ := math.cosine( rad_ )
			
			create result.make( -sin_, 0, cos_ )
		end
	
	to_top_vector : Q_VECTOR_3D is
			-- calculates a vector pointing to the top of this camera
		do
			result := to_top_vector_by_angles(alpha, beta )
		end
		
	
	to_top_vector_by_angles( alpha_, beta_ : DOUBLE ) : Q_VECTOR_3D is
			-- calculates a vector pointing to the top, by a given set of angels
		local
			rad_alpha_, sin_alpha_, cos_alpha_, rad_beta_, sin_beta_, cos_beta_ : DOUBLE
		do
			rad_alpha_ := alpha_ * pi / 180
			rad_beta_ := beta_ * pi / 180
			
			sin_alpha_ := math.sine( rad_alpha_ )
			cos_alpha_ := math.cosine( rad_alpha_ )
			
			sin_beta_ := math.sine( rad_beta_ )
			cos_beta_ := math.cosine( rad_beta_ )
		
			create result.make( -sin_alpha_ * sin_beta_, cos_beta_, cos_alpha_ * sin_beta_ )
		end
		

feature -- movement
	rotate( delta_alpha_, delta_beta_ : DOUBLE ) is
		do
			set_alpha( alpha + delta_alpha_ )
			set_beta( beta + delta_beta_ )
		end
	
	rotate_around( delta_alpha_, delta_beta_, distance_ : DOUBLE ) is
			-- rotates the camera around the point in viewdirection
			-- and width a distance of "distance_"
		do
			zoom( distance_ )
			rotate( delta_alpha_, delta_beta_ )
			zoom( -distance_ )
		end
		
	
	zoom( length : DOUBLE ) is
		local
			view_ : Q_VECTOR_3D
		do
			view_ := view_direction
			view_.normaliced
			view_.scaled( length )
			
			set_position( x + view_.x, y + view_.y, z + view_.z )
		end

	move( delta_right_, delta_top_ : DOUBLE ) is
			-- Moves the camera normal to the viewdirection of this camera
		local
			right_, top_ : Q_VECTOR_3D
		do
			right_ := to_right_vector
			top_ := to_top_vector
			
			right_.scaled( delta_right_ )
			top_.scaled( delta_top_ )
			
			right_.add( top_ )
			
			set_position( x + right_.x, y + right_.y, z + right_.z )
		end
		

feature{NONE} -- math
	math : DOUBLE_MATH is
		once
			create result
		end
	
	pi: DOUBLE is 3.14159265358979323846
	
end -- class Q_GL_CAMERA
