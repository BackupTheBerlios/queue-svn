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
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_MATERIAL_TEST
inherit
	Q_TEST_CASE
	Q_GL_OBJECT

feature
	name : STRING is "Material"	
	
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is true
	material : Q_GL_MATERIAL
	rotation : Q_GL_ROTATION

	object : Q_GL_OBJECT is
		local
			group_ : Q_GL_GROUP[ Q_GL_OBJECT ]
			light_ : Q_GL_LIGHT
		do
			create rotation.make( create {Q_VECTOR_3D}.make( 0, 1, 0 ))
			create material.make_empty
			material.set_ambient( create {Q_GL_COLOR}.make_white )
			material.set_specular( create {Q_GL_COLOR}.make_white )
			material.set_diffuse( create {Q_GL_COLOR}.make_white )
			material.set_shininess( 20 )
			
			create group_.make
			group_.extend( current )
			
			create light_.make( 0 )
			light_.set_ambient( 0, 0, 0, 1 )
			light_.set_specular( 1, 0, 0, 1 )
			light_.set_diffuse( 0.25, 0.25, 0.25, 1 )
			
			light_.set_position( 10, 0, 0 )
			light_.set_attenuation( 1, 0, 0 )
			light_.set_spot_cut_off ( 30 )
			light_.set_spot_direction( -1, 0, 0 )  
			
			group_.extend( light_ )
			result := group_
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
			create result.make( 0, 10, 10 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( 0, -10, -10 )
		end
		
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			i, j : INTEGER
		do
			rotation.set_angle( 45 )-- open_gl.current_time_millis / 10 )
			rotation.transform( open_gl )
			
			material.set( open_gl )
			
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_color_material )
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			
			open_gl.gl.gl_normal3d( 1, 0, 0 )

			from i := -20 until i = 20 loop
				from j := -20 until j = 20 loop
					open_gl.gl.gl_vertex3d( 0, i/2, j/2 )
					open_gl.gl.gl_vertex3d( 0, (i+1)/2, j/2 )
					open_gl.gl.gl_vertex3d( 0, (i+1)/2, (j+1)/2 )
					open_gl.gl.gl_vertex3d( 0, i/2, (j+1)/2 )
					
					j := j+1
				end	
				i := i+1
			end
			
			open_gl.gl.gl_end
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_color_material )
			
			rotation.untransform( open_gl )
		end
		
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
			
		end

end -- class BEN_MATERIAL_TEST
