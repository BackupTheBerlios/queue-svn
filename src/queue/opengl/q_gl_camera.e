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
			
			open_gl.gl.gl_rotated( -beta, 1, 0, 0 )
			open_gl.gl.gl_rotated( alpha, 0, 1, 0 )
			open_gl.gl.gl_translated( -x, -y, -z )
			
			end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_pop_matrix
		end

feature -- view
	x : DOUBLE -- x positon
	y : DOUBLE -- y position
	z : DOUBLE -- z position
	alpha : DOUBLE -- angle horizontal
	beta : DOUBLE -- angle vertical

	set_x( x_ : DOUBLE ) is
		do
			x := x_
		end
		
	set_y( y_ : DOUBLE ) is
		do
			y := y_
		end
		
	set_z( z_ : DOUBLE ) is
		do
			z := z_
		end
		
	set_position( x_, y_, z_ : DOUBLE ) is
		do
			x := x_
			y := y_
			z := z_
		end
		
		
	set_alpha( alpha_ : DOUBLE ) is
		do
			if alpha_ > 360 then
				alpha := alpha_ - 360
			elseif alpha_ < 0 then
				alpha := alpha_ + 360
			else
				alpha := alpha_
			end
		end
	
	set_beta( beta_ : DOUBLE ) is
		do
			if beta_ > 360 then
				beta := beta_ - 360
			elseif beta_ < 0 then
				beta := beta_ + 360
			else
				beta := beta_
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
				-sin_alpha_ * cos_beta_, sin_beta_, cos_alpha_ * cos_beta_ )
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

feature{NONE} -- math
	math : DOUBLE_MATH is
		once
			create result
		end
	
	pi: DOUBLE is 3.14159265358979323846
	
end -- class Q_GL_CAMERA
