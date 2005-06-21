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
