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
	description: "Represents a translation in the 3d space."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_TRANSLATION

inherit
	Q_GL_TRANSFORM
	redefine
		transform,
		untransform
	end
	
create
	make_from_vector
	
feature -- contructors
	make_from_vector (vector: Q_VECTOR_3D) is
			-- create a new translation
		require
			vector /= void
		do
			translation := vector
		ensure
			translation = vector
		end
		

feature -- all
	transform( open_gl : Q_GL_DRAWABLE ) is
			-- transforms a drawable. Ex: changing the matrix
		do
			open_gl.gl.gl_push_matrix
			open_gl.gl.gl_translated (translation.x, translation.y, translation.z)
		end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
			-- the opposite of transform. If transform rotate the scene by 45°, then untransform rotate the scene by -45°
		do
			open_gl.gl.gl_pop_matrix
		end
		
	set_translation (new_translation: Q_VECTOR_3D) is
			-- set the translation
		require
			new_translation /= void
		do
			translation := new_translation
		ensure
			translation = new_translation
		end
		
		
	translation: Q_VECTOR_3D

end -- class Q_GL_TRANSLATION
