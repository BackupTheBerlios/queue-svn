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

feature -- Initialization

	initialize_scene is
			-- Initialize the scene.
		local
			camera_ : Q_GL_CAMERA
		do	
			create root.init()
			root.set_inside( gl_object )
			
			create camera_
			root.set_transform( camera_ )
			
			camera_.set_alpha( 25 )
			camera_.set_beta ( -25 )
			
			camera_.set_y( 15 )
			camera_.set_x( -10 )
			
			create events.make_from_loop( event_loop )
		end		
		
feature {NONE} -- values
	events : Q_EVENT_QUEUE

	root : Q_GL_ROOT
	
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
		local
			empty_ : ANY
		do
			-- draw scene
			root.draw
			
			-- work on input
			from
				
			until
				events.is_empty
			loop
				io.put_integer( events.top_flag )
				io.put_new_line
				empty_ := events.pop_event
			end
			
			screen.redraw
		end
end
