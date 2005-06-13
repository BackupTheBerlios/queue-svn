indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BEN_TIME_HUD_TEST
inherit
	Q_TEST_CASE
	Q_HUD_CONTAINER
	redefine
		draw
	end
creation
	make

feature
	name : STRING is "Time hud"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := void
		end
	
	time : Q_TIME_INFO_HUD
	count : INTEGER
	
	set( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			count := count+1
			time.set_small_text( count.out )
			time.set_big_text( "bla" )
		end
		
	draw( ogl_ : Q_GL_DRAWABLE ) is
		local
			time_ : INTEGER
		do
			time_ := time.time_max.min( time.time + ogl_.time.delta_time_millis )
			time.set_time( time_ )
		end
		
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			button_ : Q_HUD_BUTTON
		do
			set_bounds( 0, 0, 1, 1 )
			
			create time.make
			time.set_location( 0.05, 0.9 )
			time.set_time_max( 30*1000 )
			time.set_time_cuts( 10 )
			
			create button_.make
			button_.set_bounds( 0.1, 0.1, 0.4, 0.1 )
			button_.set_text( "set" )
			button_.actions.extend( agent set )
			
			count := 0
			time.set_big_text( "Hallo" )
			time.set_small_text( "0" )
			

			
			add( time )
			add( button_ )
			result := current
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



end -- class BEN_TIME_HUD_TEST
