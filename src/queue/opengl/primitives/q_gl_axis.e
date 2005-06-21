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
	description: "A simple implementation of 3 Axis. x=red, y=green, z=blue. The size of each axis is 1, the center at point 0/0/0"
	author: "Benjamin Sigg"

class
	Q_GL_AXIS

inherit
	Q_GL_OBJECT

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl : GL_FUNCTIONS
		do
			gl := open_gl.gl
			
			gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )

			-- x
			gl.gl_color3f( 1, 0, 0 )
			
			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 1, 0, 0 )
			
			gl.gl_vertex3d( 1, 0, 0 )
			gl.gl_vertex3d( 0.75, 0, 0.25 )
			
			gl.gl_vertex3d( 1, 0, 0 )
			gl.gl_vertex3d( 0.75, 0, -0.25 )
			
			-- y
			gl.gl_color3f( 0, 1, 0 )
			
			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 0, 1, 0 )
			
			gl.gl_vertex3d( 0, 1, 0 )
			gl.gl_vertex3d( 0.25, 0.75, 0 )
			
			gl.gl_vertex3d( 0, 1, 0 )
			gl.gl_vertex3d( -0.25, 0.75, 0 )			
			
			-- z
			gl.gl_color3f( 0, 0, 1 )
			
			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 0, 0, 1 )
			
			gl.gl_vertex3d( 0, 0, 1 )
			gl.gl_vertex3d( 0.25, 0, 0.75 )
			
			gl.gl_vertex3d( 0, 0, 1 )
			gl.gl_vertex3d( -0.25, 0, 0.75 )
			
			gl.gl_end
		end
		

end -- class Q_GL_AXIS
