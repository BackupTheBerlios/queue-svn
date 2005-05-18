indexing
	description: "A scene displaying testcases, or a menu to choose testcases"

class
	Q_TEST_CASE_SCENE

inherit
	ESDL_SCENE
		redefine
			redraw
		end

creation
	make_scene

feature{NONE}
	make_scene( surface_ : ESDL_VIDEO_SUBSYSTEM ) is
		require
			surface_not_void : surface_ /= void
		do
			default_create
			surface := surface_
			initialized := false
		end
		

feature -- Initialization
	initialized : BOOLEAN

	initialize_scene is
			-- Initialize the scene.
		do	
			if not initialized then
				initialized := true
				create menus.make( 10 )
				create cases.make
				create root.init_lighting( false )
				create navigation.make
							
				generate_menus
			
				root.hud.add( navigation )
				navigation.set_bounds( 0, 0, 1, 1 )
				navigation.add( menus.first )
				create events.make( event_loop, surface )
			end
		end		
		
feature{NONE} -- hud
	navigation : Q_HUD_CAMERA_NAVIGATOR

	cases : Q_TEST_CASE_LIST
	
	menus : ARRAYED_LIST[ Q_HUD_COMPONENT ]
	
	generate_menus is
		local
			menu_ : Q_HUD_CONTAINER
			count_, index_ : INTEGER
			button_ : Q_HUD_BUTTON
			test_case_ : Q_TEST_CASE
			command_ : STRING
		do
			from
				index_ := 1
			until
				index_ > cases.count
			loop
				from
					count_ := 0	
					create menu_.make
					menu_.set_bounds ( 0, 0, 1, 1 )
					menus.extend( menu_ )
				until
					count_ = 8 or index_ > cases.count
				loop
					test_case_ := cases.i_th( index_ )
					command_ := "s"
					command_.append_integer( index_ )

					create button_.make
					button_.set_text( test_case_.name )
					button_.set_command( command_ )
					button_.actions.extend( agent action(?, ?) )
					button_.set_bounds ( 0.1, 0.1 + count_ * 0.1, 0.8, 0.09 )
					
					menu_.add( button_ )
					
					index_ := index_ + 1
					count_ := count_ + 1
				end
				
				if count_+1 < index_ then
					-- return-button
					command_ := "m"
					command_.append_integer( menus.count-1 )
					
					create button_.make
					button_.set_text( "Back" )
					button_.set_bounds( 0.2, 0.9, 0.3, 0.09 )
					button_.set_command( command_ ) 
					button_.actions.extend( agent action(?,?) )
					
					menu_.add( button_ )
				end
				
				if index_ <= cases.count then
					-- forward-button
					
					command_ := "m"
					command_.append_integer( menus.count+1 )
					
					create button_.make
					button_.set_text( "Next" )
					button_.set_bounds( 0.6, 0.9, 0.3, 0.09 )
					button_.set_command( command_ ) 
					button_.actions.extend( agent action(?,?) )
					
					menu_.add( button_ )					
				end
			end
		end

	action( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		local
			index_ : INTEGER
		do
			index_ := command_.substring ( 2, command_.count ).to_integer
				
			if command_.item ( 1 ) = 'm' then
				navigation.remove_all
				navigation.add( menus.i_th ( index_ ) )
			elseif command_.item( 1 ) = 's' then
				navigation.remove_all
				set_test_case( cases.i_th ( index_ ) )
			end
		end
		
	
feature {NONE} -- values
	events : Q_EVENT_QUEUE

	surface : ESDL_VIDEO_SUBSYSTEM

	root : Q_GL_ROOT
		
	set_test_case( test_case_ : Q_TEST_CASE ) is
		local
			hud_ : Q_HUD_COMPONENT
			object_ : Q_GL_OBJECT
			camera_ : Q_GL_CAMERA
			min_, max_, pos_, dir_ : Q_VECTOR_3D
		do
			create root.init_lighting( test_case_.lighting )
			test_case_.init
			
			hud_ := test_case_.hud
			root.hud.add( navigation )
				
			if hud_ /= void then
				navigation.add( hud_ )
			end
			
			object_ := test_case_.object
			create camera_
			root.set_transform( camera_ )
			navigation.set_camera( camera_ )
			
			if object_ /= void then
				root.set_inside( object_ )
				
				min_ := test_case_.min_bound
				max_ := test_case_.max_bound
				
				dir_ := max_.diff( min_ )
				pos_ := max_.sum ( min_ )
				
				pos_.scaled( 0.5 )
				dir_.scaled( 1.0 )
				
				camera_.set_x( pos_.x )
				camera_.set_y( pos_.y )
				camera_.set_z( pos_.z )
				
				camera_.set_alpha( -45 )
				camera_.set_beta( -45 )
				
				camera_.zoom( -dir_.length )
				navigation.set_rotation_distance( dir_.length )
			end
			
			test_case_.initialized( root )
		end
		
	
feature {NONE} -- Implementation

	redraw is
		do
			-- draw scene
			root.draw
			
			-- work on input
			root.hud.process( events )
			
			screen.redraw
		end
end
