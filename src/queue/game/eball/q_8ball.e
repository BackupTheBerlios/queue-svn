indexing
	description: "This class implements the official 8-Ball billard game and rules (according to www.billardaire.de)"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL

inherit
	Q_MODE
	Q_CONSTANTS
	
create
	make	

feature -- Interface
	light : Q_GL_LIGHT	
	player_A : Q_PLAYER -- the first player
	player_B : Q_PLAYER -- the second player
	
	set_player_a( player_ : Q_PLAYER ) is
		do
			player_a := player_
		end
	
	set_player_b( player_ : Q_PLAYER ) is
		do
			player_b := player_
		end
		
	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := player_a.first_state( ressources_ )
		end
		
	valid_position( v_ : Q_VECTOR_2D ) : BOOLEAN is
		do
			
		end
		
	
	make is
			-- creation procedure
		do
			-- create the ball_models
			new_ball_models
			-- create the model and the table
			new_table_model
			new_table
		end
		
	table : Q_TABLE	
	table_model: Q_TABLE_MODEL
	ball_models: ARRAY[Q_BALL_MODEL]

	ai_player : Q_AI_PLAYER is
		do
			result := create {Q_8BALL_NAIVE_AI_PLAYER}.make
		end
		
	
	
	human_player : Q_HUMAN_PLAYER is
			-- create a new human player for this game mode
		do
			result := create {Q_8BALL_HUMAN_PLAYER}.make_mode( current )
		end
	
	next_state : Q_GAME_STATE is
			-- next state according to the ruleset
		do
		end
		
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
		
	origin: Q_VECTOR_2D is
			-- the (0,0) of the table, this is the lower left corner, when the triangle is in the upper half
		do
			
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

	identifier : STRING is
		do
			result := "8ball"
		end
	
	install( ressources_ : Q_GAME_RESSOURCES ) is
		local
			balls: ARRAY[Q_BALL]
			ball_model: Q_BALL_MODEL
			index_: INTEGER
		do
			ressources_.gl_manager.add_object (table_model)
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
			
			if light = void then
				create light.make( 0 )
				
				light.set_diffuse( 1, 1, 1, 0 )
				light.set_position( 0, 200, 200 )
				light.set_constant_attenuation( 0 )
				light.set_attenuation( 1, 0, 0 )
		
			end
			
			ressources_.gl_manager.add_object( light )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		local
			balls: ARRAY[Q_BALL]
			ball_model: Q_BALL_MODEL
			index_: INTEGER
		do
			ressources_.gl_manager.remove_object (table_model)
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
			
			ressources_.gl_manager.remove_object( light )	
		end
		

feature {NONE} -- Implementation

	new_table is
			-- creates the opening table for this game mode, all balls are in a triangle, the white is set at the head of the table
		local
			balls_: ARRAY[Q_BALL]
			ball_ : Q_BALL
			y,nr : INTEGER
			rand_ : Q_RANDOM
			used_integers : LINKED_LIST[INTEGER]
		do
			create rand_
			-- build positions
			create used_integers.make
			
			-- create the balls
			create balls_.make (0,15)
			
			-- create the white ball
			create ball_.make_empty
			ball_.set_radius (ball_radius)
			ball_.set_number (white_number)
			ball_.set_center (head_point)
			balls_.force (ball_,white_number)
			
			used_integers.force (white_number)
			-- create the 8 (black) ball
			ball_ := ball_.deep_twin
			ball_.set_number(8)
			ball_.set_center (triangle_position (11))
			balls_.force (ball_,8)
			used_integers.force (8)
			
			-- create left rack
			ball_ := ball_.deep_twin			
			from
			until
				not used_integers.has (nr)
			loop				
				nr := rand_.random_range(1,15)
			end
			ball_.set_number (nr)
			ball_.set_center (triangle_position (1))
			balls_.force (ball_,nr)
			used_integers.force(nr)
			
			-- create right rack
			ball_ := ball_.deep_twin	
			if nr <8 then
				nr := rand_.random_range(9,15)
			else
				nr := rand_.random_range(1,7)
			end
			ball_.set_number (nr)
			ball_.set_center (triangle_position (5))
			balls_.force (ball_,nr)
			used_integers.force(nr)
			
			-- create the rest of the balls
			from
				y := 2
			until
				y > 4
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (triangle_position (y))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +1
			end
			-- skip the rack
			from
				y := 6
			until
				y > 10
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (triangle_position (y))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +1
			end
			-- skip the black
			from
				y := 12
			until
				y > 15
			loop
				ball_ := ball_.deep_twin				
				from
				until
					not used_integers.has (nr)
				loop				
					nr := rand_.random_range(1,15)
				end
				ball_.set_number (nr)
				ball_.set_center (triangle_position (y))
				used_integers.force(nr)
				balls_.force (ball_,nr)
				y := y +1
			end
			create table.make (balls_, table_model.banks, table_model.holes)
		end
		
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
		do
			create ball_models.make (0, 15)
			create loader_.make
			
			loader_.load_file ("model/pool_ball.ase")
			
			from
				index_ := ball_models.lower
			until
				index_ > ball_models.upper
			loop
				ball_models.put (create {Q_BALL_MODEL}.make_from_loader_and_texture (loader_, ball_number_to_texture_name (index_)), index_)
				
				index_ := index_ + 1
			end
		end
		
		
	new_ai_player is
			-- creates/returns an AI-Player for this game mode
		do
		end
		
	ball_number_to_texture_name (number_: INTEGER):STRING is
			-- convertes the ball number to the apropriate texture name
		do
			inspect number_
				when  0 then result := "model/voll_00_weiss.png"
				when  1 then result := "model/voll_01_gelb.png"
				when  2 then result := "model/voll_02_blau.png"
				when  3 then result := "model/voll_03_rot.png"
				when  4 then result := "model/voll_04_violett.png"
				when  5 then result := "model/voll_05_orange.png"
				when  6 then result := "model/voll_06_gruen.png"
				when  7 then result := "model/voll_07_braun.png"
				when  8 then result := "model/voll_08_schwarz.png"
				when  9 then result := "model/halb_09_gelb.png"
				when 10 then result := "model/halb_10_blau.png"
				when 11 then result := "model/halb_11_rot.png"
				when 12 then result := "model/halb_12_violett.png"
				when 13 then result := "model/halb_13_orange.png"
				when 14 then result := "model/halb_14_gruen.png"
				when 15 then result := "model/halb_15_braun.png"
			end
				
		end
		
	triangle_position (nr_: INTEGER):Q_VECTOR_2D is
			-- the nr_'s position in the opening triangle
			-- the ordering is from 1-5 last row left to right, 6-9 second last row, 10-12 middle row, 13-14 second row, 15 first row
		require
			nr_ <= 15 and nr_>=1
		local
			factor_: DOUBLE
		do
			factor_ := 0.86602540378445
			inspect nr_
			when 1 then create result.make(root_point.x+factor_*(8*ball_radius), root_point.y-4*ball_radius)
			when 2 then create result.make(root_point.x+factor_*(8*ball_radius), root_point.y-2*ball_radius)
			when 3 then create result.make(root_point.x+factor_*(8*ball_radius), root_point.y)
			when 4 then create result.make(root_point.x+factor_*(8*ball_radius), root_point.y+2*ball_radius)
			when 5 then create result.make(root_point.x+factor_*(8*ball_radius), root_point.y+4*ball_radius)
			when 6 then create result.make(root_point.x+factor_*(6*ball_radius), root_point.y-3*ball_radius)
			when 7 then create result.make(root_point.x+factor_*(6*ball_radius), root_point.y-1*ball_radius)
			when 8 then create result.make(root_point.x+factor_*(6*ball_radius), root_point.y+1*ball_radius)
			when 9 then create result.make(root_point.x+factor_*(6*ball_radius), root_point.y+3*ball_radius)
			when 10 then create result.make(root_point.x+factor_*(4*ball_radius), root_point.y-2*ball_radius)
			when 11 then create result.make(root_point.x+factor_*(4*ball_radius), root_point.y)
			when 12 then create result.make(root_point.x+factor_*(4*ball_radius), root_point.y+2*ball_radius)
			when 13 then create result.make(root_point.x+factor_*(2*ball_radius), root_point.y-ball_radius)
			when 14 then create result.make(root_point.x+factor_*(2*ball_radius), root_point.y+ball_radius)
			when 15 then create result.make(root_point.x, root_point.y)
			end
		end
		
		

	is_correct_opening(collisions_: LIST[Q_COLLISION_EVENT]):BOOLEAN is
			-- this implements rule 4.6 for a correct opening, the definition
		local
			ball_fallen_, four_balls_: BOOLEAN
			touched_balls_: LINKED_LIST[INTEGER]
			ball_ : Q_BALL
			
		do
			-- (a) a ball has fallen into a hole
			ball_fallen_ := is_any_ball_in_hole(collisions_)
			
			-- (b) or at least four balls have touched a bank
			create touched_balls_.make
			
			from
				collisions_.start
			until
				collisions_.after
			loop
				if collisions_.item.defendent.typeid = bank_type_id then
					-- it is a collision with a bank the aggressor must be a ball
					ball_ ?= collisions_.item.aggressor
					if not touched_balls_.has (ball_.number) then
						touched_balls_.force (ball_.number)
					end
				end
				collisions_.forth
			end
			four_balls_ := touched_balls_.count >=4
			
			Result := ball_fallen_ or else four_balls_
		end
		
	is_correct_shot(collisions_ :LIST[Q_COLLISION_EVENT]; player_: Q_PLAYER): BOOLEAN is
			-- implements rule 4.12 correct shot, definition
		require
			collisions_ /= Void
			player_ /= Void
		local
			own_colored_first_ :BOOLEAN
			colored_ball_fallen_ : BOOLEAN
			any_bank_touched_ : BOOLEAN
		do
			own_colored_first_ := first_ball_collision (collisions_).owner.has (player_)
			colored_ball_fallen_ := is_any_ball_in_hole (collisions_) and not is_ball_in_hole (white_number,collisions_)	
			from
				collisions_.start
			until
				collisions_.after
			loop
				any_bank_touched_ := any_bank_touched_ or collisions_.item.defendent.typeid = bank_type_id
				collisions_.forth
			end
			
			Result := own_colored_first_ and then (colored_ball_fallen_ or else any_bank_touched_)
		end

	is_any_ball_in_hole(collisions_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- has any ball fallen into a hole?
		require
			collisions_ /= Void
		do
			Result := false
			from 
				collisions_.start
			until
				collisions_.after
			loop
				Result := Result or collisions_.item.defendent.typeid = hole_type_id
				collisions_.forth
			end
		end
		
	is_ball_in_hole(ball_number_:INTEGER ; collisions_:LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- has the ball with ball_number fallen into a hole?
		require
			collisions_ /= Void
		local
			ball_ : Q_BALL
		do
			Result := false
			from 
				collisions_.start
			until
				collisions_.after
			loop
				if collisions_.item.defendent.typeid = hole_type_id then
					ball_ ?= collisions_.item.aggressor
					Result := Result or ball_.number = ball_number_
				end
				collisions_.forth
			end
		end		
		
	first_ball_collision(collisions_:LIST[Q_COLLISION_EVENT]): Q_BALL is
			-- returns the ball that the did the first collision with the white ball
		require
			collisions_ /= Void
		do
			Result ?= collisions_.first.defendent	
		end
		
	ball_radius : DOUBLE is
			-- the radius of the balls
		require
			ball_models /= void
		do
			Result := ball_models.item (ball_models.lower).radius
		end
		
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
		
invariant
	invariant_clause: True -- Your invariant here

end -- class Q_8BALL
