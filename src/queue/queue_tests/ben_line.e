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
	description: "Blupp"

class
	BEN_LINE
inherit
	Q_TEST_CASE
	Q_GL_OBJECT

feature -- to be implemented
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl : GL_FUNCTIONS
		do
			gl := open_gl.gl
			
			gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )

			gl.gl_color3f( 1, 1, 1 )

			gl.gl_vertex3d( 0, 0, 0 )
			gl.gl_vertex3d( 200, 200, 0 )

			gl.gl_vertex3d( 0, 200, 0 )
			gl.gl_vertex3d( 200, 0, 0 )
			
			gl.gl_end()
		end
		

	name : STRING is "Line"
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false
		
	object : Q_GL_OBJECT is
			-- The Object to be displayed. This can be void, if the test 
			-- wants to do something of his own
		do
			result := current
		end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		do
			result := void
		end
		
	max_bound : Q_VECTOR_3D is
			-- A vector, the maximal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( 200, 200, 0 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( 0, 0, 0 )
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end
		


end -- class BEN_LIGHT
