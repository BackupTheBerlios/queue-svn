--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
		
	rotate_around( axis_ : Q_VECTOR_3D; angle_ : DOUBLE; point_ : Q_VECTOR_3D ) is
			-- Rotates this rotation around an axis through a given point
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.rotate_at( axis_.x, axis_.y, axis_.z, angle_, point_.x, point_.y, point_.z )
			matrix := matrix_.mul( matrix )
			
			count := count+1
			if count >= orthonormalize then
				count := 0
				matrix.orthonormalize_3x3
			end			
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
