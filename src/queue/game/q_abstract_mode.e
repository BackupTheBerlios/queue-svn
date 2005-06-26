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
	description: "The abstract mode has all common things among the Q_ETH and Q_8BALL mode"
	author: "Severin Hacker"
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
		

feature {NONE} -- ini section

	read_ini_file is
			-- Read ini file.
		local
			ini_file: PLAIN_TEXT_FILE
			ini_reader: Q_INI_FILE_READER
			setting: STRING
			mu_sf, mu_rf, mass: DOUBLE
		do
			create ini_file.make_open_read ("data/abstractmode.ini")
			
			if ini_file.exists then
				create ini_reader.make
			
				ini_reader.load_ini_file (ini_file)
				
				-- take the settings
				setting := ini_reader.value ("BALL", "mu_sf")
				if setting /= void and then not setting.is_empty then
					mu_sf := setting.to_double
				end
				
				setting := ini_reader.value ("BALL", "mu_rf")
				if setting /= void and then not setting.is_empty then
					mu_rf := setting.to_double
				end
				
				setting := ini_reader.value ("BALL", "mass")
				if setting /= void and then not setting.is_empty then
					mass := setting.to_double
				end
			end
			
			-- Assign values to balls
			table.balls.do_all (agent assign_values_to_balls (?, mu_sf, mu_rf, mass))
		end
		
	assign_values_to_balls (b: Q_BALL; mu_sf, mu_rf, mass: DOUBLE) is
		do
			b.set_mu_sf (mu_sf)
			b.set_mu_rf (mu_rf)
			b.set_mass (mass)
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
		
	
feature -- camera & lights
	light_one, light_two : Q_GL_LIGHT
	
	reset_camera(ressources_: Q_GAME_RESSOURCES) is
			-- reset the camera to the headfield
		local
			pos_: Q_VECTOR_3D
		do
			-- set camera
			pos_ := ressources_.mode.position_table_to_world (create {Q_VECTOR_2D}.make (0,0))
			ressources_.gl_manager.camera.set_position (pos_.x,pos_.y+100,pos_.z)
			ressources_.gl_manager.camera.set_beta(-45)
			ressources_.gl_manager.camera.set_alpha(50)
			
		end

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
			
			reset_camera (ressources_)
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

	valid_position( v_ : Q_VECTOR_2D; ball_ : Q_BALL; sim_:Q_SIMULATION ) : BOOLEAN is
			-- is v_ a valid position, no ball in environment, not in bank, etc.
		local
			old_center: Q_VECTOR_2D
		do
			sim_.new (table,create {Q_SHOT}.make (table.balls.item (white_number), create {Q_VECTOR_2D}.default_create))
			-- DEBUG
			--io.put_string("old position: "+ball_.center.out)
			--io.put_new_line
			-- END DEBUG
			old_center := ball_.center
			ball_.set_center (v_)
			sim_.collision_detector.set_response_handler (void)
			Result := not sim_.collision_detector.collision_test(true)
			if result = false then
				ball_.set_center (old_center)
			end
			-- DEBUG 
			--io.put_string (v_.out+" for ball "+ball_.number.out+" is valid position :"+result.out)
			--io.put_new_line
			-- END DEBUG
		end
		
feature -- common game logic
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
		
	delete_fallen_balls(ressources_: Q_GAME_RESSOURCES) is
		 -- delete the fallen balls from the table (this does not delete them from the table.balls array)
		 local
			fb_ : LINKED_LIST[INTEGER]
			ball_ : Q_BALL
			x_ : DOUBLE
			i_ : INTEGER
		 do
		 	-- don't draw them and set them away from other balls
		 	i_ := ressources_.simulation.collision_list.index
			fb_ := fallen_balls (ressources_.simulation.collision_list)
			if not fb_.is_empty then
				from
					fb_.start
				until
					fb_.after
				loop
					if fb_.item /= white_number then
						ball_ := table.balls.item(fb_.item)
						--DEBUG
						--ressources_.logger.log ("Q_ABSTRACT_MODE","delete_fallen_balls", "deleting "+ball_.number.out+" table width:"+width.out)
						--END DEBUG
						ball_to_ball_model (ball_).set_visible (false)
						x_ := (ball_.number.to_double*width)/ball_models.count.to_double
						--DEBUG
						--ressources_.logger.log ("Q_ABSTRACT_MODE","delete_fallen_balls", "positioning to "+x_.out)
						--END DEBUG
						ball_.set_center (create {Q_VECTOR_2D}.make (x_,-20))
					else
						ball_ := table.balls.item(fb_.item)
						ball_.set_center (create {Q_VECTOR_2D}.make (x_,-20))
					end
					fb_.forth
				end
			end
			ressources_.simulation.collision_list.go_i_th (i_)
		end
		
	insert_ball(b_ : Q_BALL; sim_:Q_SIMULATION) is
			-- insert a ball on the fusspunkt or a position nearby
		local
			x_: DOUBLE
		do
			from
				x_ := head_point.x
				b_.set_center (head_point)
			until
				x_ >= width or else valid_position (b_.center, b_, sim_)
			loop
				b_.set_center (create {Q_VECTOR_2D}.make (x_, head_point.y))
				x_ := x_ + 0.5
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
