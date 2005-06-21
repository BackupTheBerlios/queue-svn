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
		local
			behaviour_ : Q_FREE_CAMERA_BEHAVIOUR
		do	
			if not initialized then
				initialized := true
				create cases.make
				create root.init_lighting( false )
				create navigation.make
							
				generate_menus
			
				root.hud.add( navigation )
				
				create behaviour_.make
				behaviour_.set_max_distance( 1000 )
				
				navigation.set_bounds( 0, 0, 1, 1 )
				navigation.add( menu )
				navigation.set_behaviour( behaviour_ )
				create events.make( event_loop, surface )
			end
		end		
		
feature{NONE} -- hud
	navigation : Q_HUD_CAMERA_NAVIGATOR

	cases : Q_TEST_CASE_LIST
	
--	menus : ARRAYED_LIST[ Q_HUD_COMPONENT ]
	
	menu : Q_HUD_SLIDING
	
	generate_menus is
		local
			menu_ : Q_HUD_CONTAINER
			count_, index_, menu_count_ : INTEGER
			button_ : Q_HUD_BUTTON
			test_case_ : Q_TEST_CASE
			command_ : STRING
		do
			create menu.make
			menu.set_duration( 750 )
			menu.set_bounds( 0, 0, 1, 1 )
			
			from
				index_ := 1
				menu_count_ := 0
			until
				index_ > cases.count
			loop
				from
					count_ := 0	
					create menu_.make
					menu_.set_bounds ( 0, menu_count_-0.05, 1, 1 )
--					menus.extend( menu_ )
					menu.add( menu_ )
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
				--	command_.append_integer( menus.count-1 )
					command_.append_integer( menu_count_ - 1 )
					
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
				--	command_.append_integer( menus.count+1 )
					command_.append_integer( menu_count_+1 )
					
					create button_.make
					button_.set_text( "Next" )
					button_.set_bounds( 0.6, 0.9, 0.3, 0.09 )
					button_.set_command( command_ ) 
					button_.actions.extend( agent action(?,?) )
					
					menu_.add( button_ )					
				end
				
				menu_count_ := menu_count_ + 1
			end
		end

	action( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		local
			index_ : INTEGER
		do
			index_ := command_.substring ( 2, command_.count ).to_integer
				
			if command_.item ( 1 ) = 'm' then
				menu.move_to( index_ )
--				navigation.remove_all
--				navigation.add( menus.i_th ( index_ ) )
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
	--		behaviour_ : Q_SIMPLE_CAMERA_BEHAVIOUR
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
			--	create behaviour_
			--	behaviour_.set_rotation_distance( dir_.length )
			--	navigation.set_behaviour( behaviour_ )
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
