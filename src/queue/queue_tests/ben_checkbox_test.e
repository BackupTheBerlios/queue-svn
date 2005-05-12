indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_CHECKBOX_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Checkbox"	
		
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
			box_1_, box_2_ : Q_HUD_CHECK_BOX
			panel_ : Q_HUD_CONTAINER
		do
			create box_1_.make
			create box_2_.make
			create panel_.make
			
			box_1_.set_bounds( 0.0, 0.0, 0.8, 0.2 )
			box_1_.set_font( create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false ))
			box_1_.set_font_size( 0.1 )
			box_1_.set_text( "Hallo" )
			box_1_.set_selected( true )

			box_2_.set_bounds( 0.0, 0.25, 0.8, 0.2 )
			box_2_.set_font( create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 32, false, false ))
			box_2_.set_font_size( 0.1 )
			box_2_.set_text( "Blupp" )
			box_2_.set_selected( false )
			
			panel_.set_bounds( 0.1, 0.1, 0.8, 0.5 )
			panel_.add( box_1_ )
			panel_.add( box_2_ )
			
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

end -- class BEN_CHECKBOX_TEST
