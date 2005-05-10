indexing

	description: "TODO"
	author: "Rolf Bruderer, bruderol@student.ethz.ch"
	date: "$Date: 2005/04/21 08:28:32 $"
	revision: "$Revision: 1.1 $"

class

	TABLE_SCENE

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
			
			camera_.set_alpha( 0 )
			camera_.set_beta ( 45 )
			
			camera_.set_x( 0 )
			camera_.set_y( -150 )
			camera_.set_z( 150 )
		end
		
feature {NONE} -- root
	root : Q_GL_ROOT
	
	gl_object : Q_GL_OBJECT is
		local 
			group : Q_GL_GROUP[Q_GL_OBJECT]
			loader : Q_GL_3D_OBJ_LOADER
			model : Q_GL_FLAT_MODEL
			
			light_1, light_2 :Q_GL_LIGHT
		do
			create group.make
			create loader.make
			
			loader.load_file ("model/pool.obj")
			model := loader.create_flat_model
			
			group.force(model)
			
			create light_1.make( 0 )
			create light_2.make( 1 )
			
			light_1.set_ambient( 0, 0, 0, 1 )
			light_1.set_specular( 0, 0, 0, 1 )
			light_1.set_diffuse( 0, 0, 1, 1 )
			light_1.set_position( 0, 200, 200 )
			light_1.set_constant_attenuation( 0 )
			light_1.set_linear_attenuation( 0.01 )
			
			light_2.set_ambient( 0, 0, 0, 1 )
			light_2.set_specular( 0, 0, 0, 1 )
			light_2.set_diffuse( 1, 0, 0, 1 )
			light_2.set_position( 0, -200, 200 )
			light_2.set_constant_attenuation( 0 )
			light_2.set_linear_attenuation( 0.01 )
			
			group.force( light_1 )
			group.force( light_2 )
			
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
