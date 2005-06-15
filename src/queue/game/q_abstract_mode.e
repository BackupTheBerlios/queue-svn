indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_ABSTRACT_MODE

inherit
	Q_MODE
	Q_CONSTANTS

feature -- mode	
	table : Q_TABLE	
	table_model: Q_TABLE_MODEL
	ball_models: ARRAY[Q_BALL_MODEL]
	ball_updater : Q_BALL_POSITION_UPDATER
	
feature 
	number_of_balls : INTEGER is
		-- the total number of colored balls
		deferred
		end
		
feature -- sizes & points
	width: DOUBLE is
			-- the size of the table in x-direction
		require
			table_model /= void
		do
			result := table_model.width
		end
	height: DOUBLE is
			-- the size of the table in y-direction
		require
			table_model /= void
		do
			result := table_model.height
		end
	
	root_point :Q_VECTOR_2D is
		-- fusspunkt of the table
		do
			create Result.make (3 * table_model.width / 4, table_model.height / 2)
		end
		
	head_point : Q_VECTOR_2D is
		-- the point in the middle of the head line (kopflinie)
		do
			create Result.make (table_model.width / 4, table_model.height / 2)
		end
		
	ball_radius :DOUBLE is
			-- from ball_models
		do
			result := ball_models.item (ball_models.lower).radius
		end
		
	
feature -- lights
	light_one, light_two : Q_GL_LIGHT

feature -- state

	install( ressources_ : Q_GAME_RESSOURCES ) is
		
		local
			balls: ARRAY[Q_BALL]
			ball_model: Q_BALL_MODEL
			index_: INTEGER
			pos_ : Q_VECTOR_3D
			light_position_ : Q_VECTOR_3D
		do
			ressources_.gl_manager.add_object (table_model)
			ressources_.gl_manager.add_object( ball_updater )
			balls := table.balls
			from
				index_ := balls.lower
			until
				index_ > balls.upper
			loop
				ball_model := ball_to_ball_model (balls.item (index_))			
				ball_model.set_position (position_table_to_world (balls.item (index_).center))
				ressources_.gl_manager.add_object (ball_model)				
				index_ := index_ + 1
			end
			
			if light_one = void then
				create light_one.make( 0 )
				
				light_position_ := position_table_to_world (create {Q_VECTOR_2D}.make (width / 4, height / 2))
				light_position_.add_xyz (0, 250, 0)
				
				light_one.set_diffuse( 1, 1, 1, 0 )
				light_one.set_position( light_position_.x, light_position_.y, light_position_.z )
				light_one.set_constant_attenuation( 0 )
				light_one.set_attenuation( 1, 0, 0 )
			end
			
			if light_two = void then
				create light_two.make( 1 )
				
				light_position_ := position_table_to_world (create {Q_VECTOR_2D}.make (3 * width / 4, height / 2))
				light_position_.add_xyz (0, 250, 0)
				
				light_two.set_diffuse( 1, 1, 1, 0 )
				light_two.set_position( light_position_.x, light_position_.y, light_position_.z )
				light_two.set_constant_attenuation( 0 )
				light_two.set_attenuation( 1, 0, 0 )
			end
			
			ressources_.gl_manager.add_object( light_one )
			ressources_.gl_manager.add_object( light_two )
			
			-- set camera
			pos_ := ressources_.mode.position_table_to_world (create {Q_VECTOR_2D}.make (0,0))
			ressources_.gl_manager.camera.set_position (pos_.x,pos_.y+100,pos_.z)
			ressources_.gl_manager.camera.set_beta(-45)
			ressources_.gl_manager.camera.set_alpha(50)
			
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		local
			balls: ARRAY[Q_BALL]
			ball_model: Q_BALL_MODEL
			index_: INTEGER
		do
			ressources_.gl_manager.remove_object (table_model)
			ressources_.gl_manager.remove_object( ball_updater )
			balls := table.balls
			from
				index_ := balls.lower
			until
				index_ > balls.upper
			loop
				ball_model := ball_to_ball_model (balls.item (index_))			
				ball_model.set_position (position_table_to_world (balls.item (index_).center))
				ressources_.gl_manager.remove_object (ball_model)				
				index_ := index_ + 1
			end
			
			if light_one /= void then
				ressources_.gl_manager.remove_object( light_one )
			end
			
			if light_two /= void then
				ressources_.gl_manager.remove_object( light_two )
			end	
		end

feature -- queries

	valid_position( v_ : Q_VECTOR_2D; ball_ : Q_BALL ) : BOOLEAN is
			-- is v_ a valid position, no ball in environment, not in bank, etc.
		local
			sim_: Q_SIMULATION
		do
			create sim_.make
			sim_.new (table,create {Q_SHOT}.make (table.balls.item (white_number), create {Q_VECTOR_2D}.default_create))
			sim_.collision_detector.set_response_handler (void)
			Result := not sim_.collision_detector.collision_test
		end
		
feature {Q_MODE} -- common game logic
	fallen_balls (collisions_ : LIST[Q_COLLISION_EVENT]) : LINKED_LIST[INTEGER] is
			-- all balls that have fallen into holes since last shot
		require
			collisions_ /= VOID
		local
			ball_ : Q_BALL
		do
			create Result.make
			from 
				collisions_.start
			until
				collisions_.after
			loop
				if collisions_.item.defendent.typeid = hole_type_id then
					ball_ ?= collisions_.item.aggressor
					REsult.force (ball_.number)
				end
				collisions_.forth
			end	
		end
	
	banks_touched (collisions_ : LIST[Q_COLLISION_EVENT]) : LINKED_LIST[Q_BANK] is
			-- all banks that have been touched
		require
			collisions_ /= void
		local
			bank_ : Q_BANK
		do
			create Result.make
			from 
				collisions_.start
			until
				collisions_.after
			loop
				if collisions_.item.defendent.typeid = bank_type_id then
					bank_ ?= collisions_.item.defendent
					REsult.force (bank_)
				end
				collisions_.forth
			end	
		end

feature -- helper functions

	ball_to_ball_model(ball_ :Q_BALL):Q_BALL_MODEL is
			-- see base class
		local 
			i:INTEGER
		do
			from
				i := table.balls.lower
			until
				i > table.balls.upper
			loop
				if table.balls.item(i) = ball_ then
					Result := ball_models.item (i)
				end
				
				i := i + 1
			end
		end
	
	ball_number_to_texture_name (number_: INTEGER):STRING is
			-- converts the ball number to the apropriate texture name
		deferred	
		end
		
feature -- set-up

	new_table_model is
			-- creates/returns a 3D-model of the table for this game mode
		do
			create table_model.make_from_file ("model/pool.ase")
		end

	new_ball_models is
			-- creates the 3d-models of the balls (creates ball_models)
		local
			loader_: Q_GL_3D_ASE_LOADER
			
			index_: INTEGER
			
			model_: Q_BALL_MODEL
			rand_: RANDOM
			axis_: Q_VECTOR_3D
		do
			create ball_models.make (0, number_of_balls)
			create loader_.make
			create rand_.make
			
			rand_.start
			loader_.load_file ("model/pool_ball.ase")
			
			from
				index_ := ball_models.lower
			until
				index_ > ball_models.upper
			loop
				create model_.make_from_loader_and_texture (loader_, ball_number_to_texture_name (index_))
				create axis_.default_create
				
				axis_.set_x (rand_.double_item)
				rand_.forth
				axis_.set_y (rand_.double_item)
				rand_.forth
				axis_.set_z (rand_.double_item)
				rand_.forth
				
				axis_.normaliced
				
				model_.add_rotation (axis_, rand_.double_item * 2 * 3.14)
				rand_.forth
				
				ball_models.put (model_, index_)
				
				index_ := index_ + 1
			end
		end
		

	stretch is
			-- stretch the positions of the balls in the triangle to avoid collisions at the beginning of the game
		local
			center_of_triangle_ : Q_VECTOR_2D
			factor_, scale_factor_: DOUBLE
			i: INTEGER
			center_to_ball_ : Q_VECTOR_2D
		do
			factor_ := 0.86602540378445
			scale_factor_ := 1.05
			create center_of_triangle_.make (root_point.x+factor_*5*ball_radius,root_point.y)
			from
				i := table.balls.lower
			until
				i > table.balls.upper
			loop
				center_to_ball_ := table.balls.item (i).center - center_of_triangle_
				center_to_ball_.scale (scale_factor_)
				table.balls.item(i).set_center (center_of_triangle_+center_to_ball_)
				i := i+1
			end
		end
		
		
	link_table_and_balls is
		local
			index_ : INTEGER
		do
			table_model.balls.wipe_out
			
			-- link table and balls
			from
				index_ := ball_models.lower
			until
				index_ > ball_models.upper
			loop
				ball_models.item( index_ ).set_ball( table.balls.item( index_ ))
				table_model.balls.extend( ball_models.item( index_ ))
				index_ := index_ + 1
			end			
		end
		

end -- class Q_ABSTRACT_MODE