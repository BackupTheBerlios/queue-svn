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
	description: "A line broken in several sublines"
	author: "Benjamin Sigg"

class
	Q_GL_BROKEN_LINE
	
inherit
	Q_GL_OBJECT
	
creation
	make_empty, make
	
feature{NONE} -- creation
	make_empty is
		do
			make( create {Q_VECTOR_3D}.make( 0, 0, 0 ),
					create {Q_VECTOR_3D}.make( 0, 1, 0 ), 10 )
		end
		
	make( a_, b_ : Q_VECTOR_3D; pieces_ : INTEGER ) is
		do
			set_a( a_ )
			set_b( b_ )
			set_pieces( pieces_ )
		end
		
	
feature -- draw
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			index_, points_ : INTEGER
			relative_ : DOUBLE
			ax_, ay_, az_, bx_, by_, bz_ : DOUBLE
		do
			ax_ := a.x
			ay_ := a.y
			az_ := a.z

			bx_ := b.x
			by_ := b.y
			bz_ := b.z
			
			points_ := pieces * 2

			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_lighting )
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )
			
			if color /= void then
				color.set( open_gl )
			end			
			
			from index_ := 0 until index_ >= points_ loop
				relative_ := index_ / (points_-1)
				
				open_gl.gl.gl_vertex3d( 
					ax_ * (1-relative_) + bx_ * relative_,
					ay_ * (1-relative_) + by_ * relative_,
					az_ * (1-relative_) + bz_ * relative_ )
				
				index_ := index_ + 1
			end
			
			open_gl.gl.gl_end
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_lighting )
		end
		

feature -- values
	a, b : Q_VECTOR_3D
		-- start and end-position of the line
		
	pieces : INTEGER
		-- The number of pieces this line contains
		
	color : Q_GL_COLOR
		-- the material
		
	normal : Q_VECTOR_3D
		-- the normal
		
	set_a( a_ : Q_VECTOR_3D ) is
		do
			a := a_
		end
		
	set_b( b_ : Q_VECTOR_3D ) is
		do
			b := b_
		end
		
	set_pieces( pieces_ : INTEGER ) is
		do
			pieces := pieces_
		end
	
	set_color( color_ : Q_GL_COLOR ) is
		do
			color := color_
		end
	
end -- class Q_GL_BROKEN_LINE
