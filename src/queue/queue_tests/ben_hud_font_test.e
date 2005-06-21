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
	BEN_HUD_FONT_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Font"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is do
		result := void
	end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			label_ : Q_HUD_LABEL
			font_ : Q_HUD_FONT
		do
			font_ := create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 64, false, false );
			create label_.make

--	create button_.make
--					button_.set_text( test_case_.name )
--					button_.set_font( font_ )
--					button_.set_font_size( 0.05 )
--					button_.set_command( command_ )
			
			
			label_.set_bounds( 0.1, 0.1, 0.8, 0.8 )
			label_.set_text ( "bla" )
			label_.set_font ( font_ )
			label_.set_font_size( 0.5 )
			label_.set_alignement_x( 0.3 )
			label_.set_background( create {Q_GL_COLOR}.make_orange  )
			
			result := label_
		end
		
	max_bound : Q_VECTOR_3D is do
		result := void
	end
		
	min_bound : Q_VECTOR_3D is do
		result := void
	end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end


end -- class BEN_HUD_FONT_TEST
