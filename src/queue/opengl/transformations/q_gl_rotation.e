indexing
	description: "Represents a rotation in the 3d space."
	author: "Benjamin Sigg"
	coauthor: "Basil Fierz"

class
	Q_GL_ROTATION

inherit
	Q_GL_TRANSFORM
	redefine
		transform,
		untransform
	end
	
creation
	make, make_rotated
	
feature {NONE} -- creation
	make( axis_ : Q_VECTOR_3D ) is
		do
			set_axis( axis_ )
		end
		
	make_rotated( axis_ : Q_VECTOR_3D; angle_ : REAL ) is
		do
			set_axis( axis_ )
			set_angle( angle_ )
		end
		
	
feature -- all
	axis : Q_VECTOR_3D
	angle : REAL
	
	set_axis( axis_ : Q_VECTOR_3D ) is
		require
			axis_not_void : axis_ /= void
			axis_not_null_vector : axis_.length > 0
		do
			axis := axis_
		end
		
	set_angle( angle_ : REAL ) is
		do
			angle := angle_
		end
		

	transform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_push_matrix
			open_gl.gl.gl_rotated( angle,  axis.x, axis.y, axis.z )
		end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_pop_matrix
		end


end -- class Q_GL_ROTATION
