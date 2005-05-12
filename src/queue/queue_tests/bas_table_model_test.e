indexing

class
	BAS_TABLE_MODEL_TEST

inherit
	Q_TEST_CASE

feature
	name : STRING is "Table model test"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is true

	object : Q_GL_OBJECT is
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
			light_1.set_attenuation( 1, 0, 0 )
			
			light_2.set_ambient( 0, 0, 0, 1 )
			light_2.set_specular( 0, 0, 0, 1 )
			light_2.set_diffuse( 1, 0, 0, 1 )
			light_2.set_position( 0, -200, 200 )
			light_2.set_attenuation( 1, 0, 0 )
			
			group.force( light_1 )
			group.force( light_2 )
			
			result := group
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
			create result.make( 60, 60, 60 )
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make( -60, -60, -60 )
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
--		local
--			camera_ : Q_GL_CAMERA
		do				
--			create camera_
--			root_.set_transform( camera_ )
			
--			camera_.set_alpha( 0 )
--			camera_.set_beta ( 45 )
			
--			camera_.set_x( 0 )
--			camera_.set_y( -150 )
--			camera_.set_z( 150 )
		end


end -- class BEN_COLOR_CUBE_TEST

