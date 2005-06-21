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

class
	BAS_BIG_8BALL_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Big 8Ball Test "	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is true

	object : Q_GL_OBJECT is
		local 
			group: Q_GL_GROUP[Q_GL_OBJECT]
			
			light_1, light_2 :Q_GL_LIGHT
			
			eball: Q_8BALL
			balls: ARRAY[Q_BALL]
			ball_model: Q_BALL_MODEL
			
			index_: INTEGER
		do
			create group.make
			
			create eball.make
			
			group.extend (eball.table_model)
			
			balls := eball.table.balls
			from
				index_ := balls.lower
			until
				index_ > balls.upper
			loop
				ball_model := eball.ball_to_ball_model (balls.item (index_))
				
				ball_model.set_position (eball.position_table_to_world (balls.item (index_).center))
				group.extend (ball_model)
				
				index_ := index_ + 1
			end
			
			create light_1.make( 0 )
			create light_2.make( 1 )
			
			--light_1.set_ambient( 1, 1, 1, 0 )
			--light_1.set_specular( 1, 1, 1, 0 )
			light_1.set_diffuse( 1, 1, 1, 0 )
			light_1.set_position( 0, 200, 200 )

			light_1.set_constant_attenuation( 0 )
			light_1.set_attenuation( 1, 0, 0 )

			
			light_2.set_ambient( 1, 1, 0, 0 )
			light_2.set_specular( 1, 1, 0, 0 )
			light_2.set_diffuse( 1, 1, 0, 0 )
			light_2.set_position( 0, -200, 200 )
			light_2.set_attenuation( 1, 0, 0 )
			
			group.force( light_1 )
			--group.force( light_2 )
			
			result := group
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
			create result.make( 60, 60, 60 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( -60, -60, -60 )
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called afte6 the test-case is initialized. If you want, you
			-- can change some settings...
--		local
--			camera_ : Q_GL_CAMERA
		do				
	--		root_.set_transform( camera_ )
--			create camera_
--			root_.set_transform( camera_ )
			
--			camera_.set_alpha( 0 )
--			camera_.set_beta ( 45 )
			
--			camera_.set_x( 0 )
--			camera_.set_y( -150 )
--			camera_.set_z( 150 )
		end


end -- class BEN_COLOR_CUBE_TEST

