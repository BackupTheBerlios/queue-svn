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
	description: "A test of the Q_MATRIX_4X4"
class
	BEN_MATRIX_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Matrix 4x4"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		local
			group_ : Q_GL_GROUP[ Q_GL_OBJECT ]
			transform_group_ : Q_GL_TRANSFORMED_GROUP[ Q_GL_OBJECT ]
			transform_ : Q_GL_MATRIX_TRANSFORM
			cube_ : Q_GL_COLOR_CUBE
			
			index_ : INTEGER
			count_ : INTEGER
		do
			create group_.make
			
			from
				index_ := 0
				count_ := 100
			until
				index_ = count_
			loop
				create transform_group_.make
				create cube_.make_sized( 5 )
				create transform_.make
				
				transform_.matrix.rotate( 1, 1, 1, index_ / (count_-1) * 3.14 * 2 )
--				transform_.matrix.rotate( 0, 1, 0, index_ / (count_-1) * 3.14 / 2 )				
--				transform_.matrix.rotate( 0, 0, 1, index_ / (count_-1) * 3.14 / 2 )
				
				transform_.matrix.translate( index_ * 7, 0, -10 )
				
				transform_.matrix.orthonormalize_3x3
				
				transform_group_.set_transform( transform_ )
				transform_group_.extend( cube_ )
				
				group_.extend( transform_group_ )
		--		group_.extend( cube_ )
				
				index_ := index_ + 1
			end
			
			-- add a axis
			create transform_.make
			create transform_group_.make
			transform_.matrix.translate( 0, 10, 0 )
			transform_group_.set_transform( transform_ )
			transform_group_.extend( create {Q_GL_AXIS} )
			
			group_.extend( transform_group_ )
			
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
			create result.make( 500, 0, 0 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( 20, 0, 0 )
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end

end -- class BEN_MATRIX_TEST
