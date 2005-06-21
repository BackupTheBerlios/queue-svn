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

	author: ""

class

	FIRST_SCENE

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
			camera_ : Q_GL_CAMERA
		do	
			if not initialized then
				initialized := true
				
				create root.init_lighting( true )
				root.set_inside( gl_object )
				root.hud.add( gl_hud )
			
				create camera_
				root.set_transform( camera_ )
			
				camera_.set_alpha( 25 )
				camera_.set_beta ( -25 )
			
				camera_.set_y( 15 )
				camera_.set_x( -10 )
			
				create events.make( event_loop, surface )
			end
		end		
		
feature {NONE} -- values
	events : Q_EVENT_QUEUE

	surface : ESDL_VIDEO_SUBSYSTEM

	root : Q_GL_ROOT
	
	gl_hud : Q_HUD_COMPONENT is
		local
			hud_ : SIMPLE_HUD_CONTAINER
			child_ : Q_HUD_CONTAINER
		do
			create hud_.make_color ( 0, 0.2, 0 )
			hud_.set_size( 0.6, 0.8 )
			
			child_ := buttons
			child_.set_location ( 0, 0.1 )
			hud_.add( child_ )
			
			child_ := buttons
			child_.set_location ( 0.1, 0.5 )
			hud_.add( child_ )
			
			result := hud_
		end
	
	buttons : Q_HUD_CONTAINER is
		local
			hud_ : SIMPLE_HUD_CONTAINER
			font_ : Q_HUD_IMAGE_FONT

			button_1, button_2 : Q_HUD_BUTTON
		do
			create hud_.make_color( 0.5, 0.5, 0.5 )
			create font_.make_standard ( "Arial", 32, false, false )
			create button_1.make
			create button_2.make
			
			hud_.set_size ( 0.5, 0.3 )
			hud_.add( button_1 )
			hud_.add( button_2 )
			
			button_1.set_font( font_ )
			button_2.set_font( font_ )
			
			button_1.set_font_size( 0.0625 )
			button_2.set_font_size( 0.0625 )
			
			button_1.set_bounds( 0.0, 0.0, 0.4, 0.1 )
			button_2.set_bounds( 0.0, 0.1, 0.4, 0.1 )
			
			button_1.set_text( "Button 1" )
			button_2.set_text( "Button 2" )
			
			button_1.actions.extend( agent button_call(?, ?) )
			button_2.actions.extend( agent button_call(?, ?) )
			
			result := hud_	
		end
		
	
	button_call( command_ : STRING; button_ : Q_HUD_BUTTON ) is
		do
			io.put_string( command_ )
			io.put_new_line
		end
	
	gl_object : Q_GL_OBJECT is
		local 
			group : Q_GL_GROUP[Q_GL_OBJECT]
			
			light_1, light_2, light_3 : Q_GL_LIGHT
		do
			create group.make
			
			group.force( create {Q_GL_WHITE_CUBE}.make_positioned_and_sized( 0, 0, -20, 5 ))
			group.force( create {Q_GL_WHITE_CUBE}.make_positioned_and_sized( 10, 0, -20, 5 ))
			group.force( create {Q_GL_WHITE_CUBE}.make_positioned_and_sized( 0, 10, -20, 5 ))
			group.force( create {Q_GL_WHITE_CUBE}.make_positioned_and_sized( -10, 0, -20, 5 ))
			group.force( create {Q_GL_WHITE_CUBE}.make_positioned_and_sized( 0, -10, -20, 5 ))
			
			
			create light_1.make( 0 )
			create light_2.make( 1 )	
			create light_3.make( 2 )
			
			light_1.set_ambient( 0, 0, 0, 1 )
			light_1.set_specular( 0, 0, 0, 1 )
			light_1.set_diffuse( 0, 0, 1, 1 )
			light_1.set_position( 0, 20, -10 )
			
			light_2.set_ambient( 0, 0, 0, 1 )
			light_2.set_specular( 0, 0, 0, 1 )
			light_2.set_diffuse( 1, 0, 0, 1 )
			light_2.set_position( -10, -20, -10 )

			light_3.set_ambient( 0, 0, 0, 1 )
			light_3.set_specular( 0, 0, 0, 1 )
			light_3.set_diffuse( 0, 1, 0, 1 )
			light_3.set_position( 0, -10, 0 )
			
			light_3.set_spot_cut_off ( 20 )
			light_3.set_spot_direction ( 0.25, 1, -1 )
			light_3.set_spot_exponent ( 0 )
			
			group.force( light_1 )
			group.force( light_2 )
			group.force( light_3 )
			
			result := group
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
