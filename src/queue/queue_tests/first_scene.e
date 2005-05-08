indexing

	description: "TODO"
	author: "Rolf Bruderer, bruderol@student.ethz.ch"
	date: "$Date: 2005/04/21 08:28:32 $"
	revision: "$Revision: 1.1 $"

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
			hud_, child_ : SIMPLE_HUD_CONTAINER
			font : Q_HUD_IMAGE_FONT
			label_1, label_2 : Q_HUD_LABEL
		do
			create hud_.make_color( 1, 0, 0 )
			create child_.make_color( 0, 0, 1 )
			create font.make ("data/font/Arial.txt", "data/font/Arial.png" )
			create label_1
			create label_2
			
			label_1.set_font( font )
			label_1.set_text( "The Q_HUD_IMAGE_FONT has more abbilities than ESDL" )
			label_1.set_bounds( 0.0, 0.3, 1.0, 0.5 )
			label_1.set_font_size( 0.025 )
			
			label_2.set_font( font )
			label_2.set_text( "For example: not every character has the same width..." )
			label_2.set_bounds( 0.0, 0.33, 1.0, 0.5 )
			label_2.set_font_size( 0.025 )
			
			hud_.set_bounds ( 0.0, 0.1, 0.2, 0.2 )			
			child_.set_bounds( 0.1, 0.1, 0.2, 0.2 )

			hud_.add( label_1 )
			hud_.add( label_2 )
			hud_.add( child_ )
			
			result := hud_
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
