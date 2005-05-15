indexing
	description: "Changes the entries of the matrix directly"
	author: "Benjamin Sigg"

class
	Q_GL_MATRIX_TRANSFORM

inherit
	Q_GL_TRANSFORM
	
creation
	make
	
feature{NONE} -- creation
	make is
		do
			create matrix.identity
		end
		
feature -- transform
	transform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_push_matrix
			matrix.set( open_gl )			
		end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_pop_matrix
		end
		
	
feature -- matrix
	matrix : Q_MATRIX_4X4
	
	set_matrix( matrix_ : Q_MATRIX_4X4 ) is
		require
			matrix_exists : matrix_ /= void
		do
			matrix := matrix_
		end
		

end -- class Q_GL_MATRIX_TRANSFORM
