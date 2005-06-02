indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_SLIDER_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Slider"	
		
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
			slider_ : Q_HUD_SLIDER
			panel_ : Q_HUD_CONTAINER
		do
			create panel_.make	
			panel_.set_bounds( 0, 0, 1, 1 )
			
			create slider_.make
			panel_.add( slider_ )
			
			slider_.set_bounds( 0.1, 0.1, 0.8, 0.1 )
			slider_.set_min_max( 0, 10 )
			slider_.set_value( 7 )
			
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


end -- class BEN_SLIDER_TEST
