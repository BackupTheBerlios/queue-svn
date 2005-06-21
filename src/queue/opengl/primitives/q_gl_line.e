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
	description: "A line in the 3d space."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/24 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_LINE

inherit
	Q_GL_OBJECT

create
	make_position_material
	
feature {NONE} -- creation
	make_position_material (start_, stop_: Q_VECTOR_3D; material_: Q_GL_MATERIAL) is
			-- create a line with a material
		do
			start := start_
			stop := stop_
			material := material_
		end
		

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl : GL_FUNCTIONS
		do
			gl := open_gl.gl
			
			gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )

			material.set (open_gl )

			-- start
			gl.gl_vertex3d (start.x, start.y, start.z)
			-- end
			gl.gl_vertex3d (stop.x, stop.y, stop.z)
			
			gl.gl_end
		end
		
feature -- access
	start, stop : Q_VECTOR_3D
	
	material : Q_GL_MATERIAL
	
invariant
	start /= void
	stop /= void
	material /= void
	
end -- class Q_GL_LINE
