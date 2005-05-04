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
		end
		
feature {NONE} -- root
	root : Q_GL_ROOT
	
	gl_object : Q_GL_OBJECT is
		local 
			group : Q_GL_GROUP[Q_GL_OBJECT]
		do
			create group.make
			
			group.force( create {Q_GL_COLOR_CUBE}.make_positioned_and_sized( 0, 0, -20, 5 ))
			group.force( create {Q_GL_COLOR_CUBE}.make_positioned_and_sized( 10, 0, -20, 5 ))
			group.force( create {Q_GL_COLOR_CUBE}.make_positioned_and_sized( 0, 10, -20, 5 ))
			group.force( create {Q_GL_COLOR_CUBE}.make_positioned_and_sized( -10, 0, -20, 5 ))
			group.force( create {Q_GL_COLOR_CUBE}.make_positioned_and_sized( 0, -10, -20, 5 ))
			
			result := group
		end
		
		
feature {NONE} -- Implementation

	redraw is
			-- Draw all
		do
			root.draw
			screen.redraw
		end
end
