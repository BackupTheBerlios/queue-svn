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
		
	set_alpha( alpha_ : DOUBLE ) is
		do
			alpha := alpha_
		end
	
	set_beta( beta_ : DOUBLE ) is
		do
			beta := beta_
		end
	
end -- class Q_GL_CAMERA
