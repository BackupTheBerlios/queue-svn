indexing
	description: "Test showing a light"

class
	BEN_LIGHT_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Benis Lights"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is true

	object : Q_GL_OBJECT is
		local
			group_ : Q_GL_GROUP[ Q_GL_OBJECT ]
			light_ : Q_GL_LIGHT
		do
			create light_.make( 0 )
			create group_.make

			group_.extend( create {Q_GL_WHITE_CUBE}.make_sized( 20 ) )
			group_.extend( light_ )
			
			light_.set_ambient( 0, 0, 1, 1 )
			light_.set_specular( 0, 0, 0, 1 )
			light_.set_diffuse( 0, 1, 0, 1 )
			light_.set_position( 15, 20, 15 )
			
			light_.set_spot_cut_off ( 40 )
			light_.set_spot_direction ( 0, -1, -0.5 )
			light_.set_spot_exponent ( 0 )
			
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

end -- class BEN_LIGHT_TEST