class
	BEN_BALL_CAMERA_BEHAVIOUR_TEST
	

inherit
	Q_TEST_CASE

feature
	name : STRING is "Ball Camera"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := create {Q_GL_COLOR_CUBE}.make_sized( 20 )
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
		local
			navigator_ : Q_HUD_CAMERA_NAVIGATOR
			camera_ : Q_GL_CAMERA
			ball_ : Q_BALL
			behaviour_ : Q_BALL_CAMERA_BEHAVIOUR
		do
			create camera_
			create navigator_.make_camera( camera_ )
			
			create ball_.make( create {Q_VECTOR_2D}.make( 0, 0 ), 2 )
			create behaviour_.make
			
			behaviour_.set_ball( ball_ )
			navigator_.set_behaviour( behaviour_ )
			
			navigator_.set_bounds( 0, 0, 1, 1 )
			
			root_.hud.remove_all
			root_.hud.add (navigator_ )
			root_.set_transform( camera_ ) 
		end


end -- class BEN_BALL_CAMERA_BEHAVIOUR_TEST
