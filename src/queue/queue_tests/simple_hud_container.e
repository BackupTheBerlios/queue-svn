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
	description: "A container with a background color, but no spezial abilities"

class
	SIMPLE_HUD_CONTAINER

inherit
	Q_HUD_CONTAINER
	redefine
		draw
	end

creation
	make_color
	
feature
	make_color( red_, green_, blue_ : DOUBLE ) is
		do
			default_create
			make
			create color.make_rgb( red_, green_, blue_ )
		end
		
	draw( open_gl : Q_GL_DRAWABLE ) is
		do

			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			color.set( open_gl )
			
			open_gl.gl.gl_vertex2d( 0, 0 )
			open_gl.gl.gl_vertex2d( 0, height )
			open_gl.gl.gl_vertex2d( width, height )
			open_gl.gl.gl_vertex2d( width, 0 )			
			
			open_gl.gl.gl_end
			
			precursor( open_gl )
		end
		

feature
	color : Q_GL_COLOR

end -- class SIMPLE_HUD_CONTAINER
