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
	BEN_TEXTFIELD_TEST


inherit
	Q_TEST_CASE

feature
	name : STRING is "Textfield"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := void
		end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			field_1_, field_2_ : Q_HUD_TEXT_FIELD
			panel_ : Q_HUD_CONTAINER
		do
			create field_1_.make
			create field_2_.make
			create panel_.make
			
			field_1_.set_bounds( 0.0, 0.0, 0.8, 0.2 )
			field_1_.set_font( create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false ))
			field_1_.set_font_size( 0.1 )
			field_1_.set_text( "Hallo" )
			field_1_.set_alignement_x ( 0.0 )

			field_2_.set_bounds( 0.0, 0.25, 0.8, 0.2 )
			field_2_.set_font( create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false ))
			field_2_.set_font_size( 0.1 )
			field_2_.set_text( "Blupp" )
			field_2_.set_alignement_x ( 1.0 )
			
			panel_.set_bounds( 0.1, 0.1, 0.8, 0.5 )
			panel_.add( field_1_ )
			panel_.add( field_2_ )
			
			result := panel_
		end
		
	max_bound : Q_VECTOR_3D is
			-- A vector, the maximal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( 10, 10, 10 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( -10, -10, -10 )
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end


end -- class BEN_TEXTFIELD_TEST
