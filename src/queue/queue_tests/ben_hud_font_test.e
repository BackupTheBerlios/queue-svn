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
