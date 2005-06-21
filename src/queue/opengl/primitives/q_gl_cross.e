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
	description: "An object that draws a simple cross (a line for each direction)"
	author: "Benjamin Sigg"

class
	Q_GL_CROSS

inherit
	Q_GL_OBJECT

creation
	make
	
feature{NONE} -- creation
	make( position_ : Q_VECTOR_3D; color_ : Q_GL_COLOR; size_ : DOUBLE ) is
		do
			set_position( position_ )
			set_color( color_ )
			set_size( size_ )
		end
		
feature -- draw
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_lighting )
			
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )
			color.set( open_gl )
			
			open_gl.gl.gl_vertex3d( position.x-size, position.y, position.z )
			open_gl.gl.gl_vertex3d( position.x+size, position.y, position.z )

			open_gl.gl.gl_vertex3d( position.x, position.y+size, position.z )
			open_gl.gl.gl_vertex3d( position.x, position.y-size, position.z )
			
			open_gl.gl.gl_vertex3d( position.x, position.y, position.z+size )
			open_gl.gl.gl_vertex3d( position.x, position.y, position.z-size )			
			
			open_gl.gl.gl_end
			
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
		end
		

feature -- position and size
	position : Q_VECTOR_3D
	color : Q_GL_COLOR
	size : DOUBLE
	
	set_position( position_ : Q_VECTOR_3D ) is
		require
			position_ /= void
		do
			position := position_
		end
		
	set_color( color_ : Q_GL_COLOR ) is
		require
			color_ /= void
		do
			color := color_
		end

	set_size( size_ : DOUBLE ) is
		do
			size := size_
		end
	
end -- class Q_GL_CROSS
