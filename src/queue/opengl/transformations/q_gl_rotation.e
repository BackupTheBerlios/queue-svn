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
