indexing
--	description: A rotation over an x/y/z axis. The rotation itself can be rotated over 
--      an other axis, as many times as needed. The rotations will be summed up.
--		The rotation is numerical stabel in the sens, that at any time, the equations 
--		<a,b> = <R*a, R*b> and |a| = |R*a| holds for all vectors a, b and the rotation R. 
--		The rotation is numerical unstable in the sens, that rotating n times alpha degrees
--		does not result	in a n*alpha-degree rotation.
	author: "Benjamin Sigg"

class
	Q_GL_MULTI_ROTATION

inherit
	Q_GL_TRANSFORM

creation
	make

feature{NONE} -- creation
	make is
		do
			create matrix.identity
			count := 0
		end
		
feature{NONE} -- matrix
	matrix : Q_MATRIX_4X4
	
	orthonormalize : INTEGER is 10000
	
	count : INTEGER

feature -- Transformation
	transform (open_gl: Q_GL_DRAWABLE) is
		do
			open_gl.gl.gl_push_matrix
			matrix.set( open_gl )
		end

	untransform (open_gl: Q_GL_DRAWABLE) is
		do
			open_gl.gl.gl_pop_matrix
		end

	reset is
			-- Resets the Rotation (this Transform will no longer influence the scene, until a new rotation is applied)
		do
			matrix.identity
			count := 0
		end
		
	rotate( axis_ : Q_VECTOR_3D; angle_ : DOUBLE ) is
			-- Rotates this rotation clockwise. The angle is measured in radians
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.rotate_vector( axis_, angle_ )
			matrix := matrix.mul( matrix_ )
			
			count := count+1
			if count >= orthonormalize then
				count := 0
				matrix.orthonormalize_3x3
			end
		end
		

end -- class Q_GL_MULTI_ROTATION
