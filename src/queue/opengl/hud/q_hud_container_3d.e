indexing
	description: "A container who rotates, translates and scales its children"
	author: "Benjamin Sigg"

class
	Q_HUD_CONTAINER_3D
	
inherit
	Q_HUD_CONTAINER
	redefine
		make,
		draw_foreground,
		convert_direction,
		convert_point
	end

creation
	make

feature{NONE} -- creation
	make is
	do
		precursor
		create matrix
	end
		

feature -- drawing
	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_push_matrix
			matrix.set( open_gl )
			precursor( open_gl )
			open_gl.gl.gl_pop_matrix
		end
		

feature -- Conversion
	matrix : Q_MATRIX_4X4
	
	convert_direction (direction_: Q_VECTOR_3D): Q_VECTOR_3D is
		do
			result := matrix.inverted.mul_vector_3( direction_ )
		end

	convert_point (x_, y_: DOUBLE; direction_: Q_VECTOR_3D): Q_VECTOR_2D is
		do
			
		end

end -- class Q_HUD_CONTAINER_3D
