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

feature -- creation
	
	make is
			-- creation procedure
		do
			-- create the ball_models
			new_ball_models
			-- create the model and the table
			new_table_model
			new_table
			
			-- create hud
			create info_hud.make_ordered( true )
			info_hud.set_location( 0.05, 0.75 )
		end
		
feature	-- Interface
	light_one, light_two : Q_GL_LIGHT	
	table : Q_TABLE	
	table_model: Q_TABLE_MODEL
	ball_models: ARRAY[Q_BALL_MODEL]
	player_A : Q_PLAYER -- the first player
	player_B : Q_PLAYER -- the second player
	info_hud : Q_2_INFO_HUD -- the informations for the user
	
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
	
	ai_player : Q_AI_PLAYER is
		do
			result := create {Q_8BALL_NAIVE_AI_PLAYER}.make
		end
	
	human_player : Q_HUMAN_PLAYER is
			-- create a new human player for this game mode
		do
			result := create {Q_8BALL_HUMAN_PLAYER}.make_mode( current )
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
		
feature --helper functions
		
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
		

	
feature -- state features

	install( ressources_ : Q_GAME_RESSOURCES ) is
		local
			balls: ARRAY[Q_BALL]
			ball_model: Q_BALL_MODEL
			index_: INTEGER
			pos_ : Q_VECTOR_3D
			light_position_ : Q_VECTOR_3D
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
			
			-- set first shot
			first_shot := true
			
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
			
			if light_one /= void then
				ressources_.gl_manager.remove_object( light_one )
			end
			
			if light_two /= void then
				ressources_.gl_manager.remove_object( light_two )
			end	
		end
		
			
	next_state (ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- next state according to the ruleset
		local
			reset_state_ : Q_8BALL_RESET_STATE
			aim_state_ : Q_8BALL_AIM_STATE
			choice_state_ : Q_8BALL_CHOICE_STATE
			colls_ : LIST[Q_COLLISION_EVENT]
			ball_: Q_BALL
		do
			ressources := ressources_
			colls_ := ressources_.simulation.collision_list
			if is_game_lost(colls_) then
				create choice_state_.make_mode_titled( current, active_player.name+" loses", "id", 2)
				choice_state_.button (1).set_text ("Play again")
				choice_state_.button (1).actions.force (agent handle_restart)
				choice_state_.button (2).set_text ("Main menu")
				choice_state_.button (2).actions.force (agent handle_main_menu)
				Result := choice_state_
			elseif is_game_won(colls_) then
				create choice_state_.make_mode_titled (current, active_player.name+" wins", "id", 2)
				choice_state_.button (1).set_text ("Play again")
				choice_state_.button (1).actions.force (agent handle_restart)
				choice_state_.button (2).set_text ("Main menu")
				choice_state_.button (2).actions.force (agent handle_main_menu)
				Result := choice_state_
			elseif first_shot and then not is_correct_opening (colls_) then
				-- rule 4.6 second part
--				-- the current player made an error, the other player can
--				a) die Position so übernehmen und weiterspielen oder
--				b) die Kugeln neu aufbauen lassen und selbst einen neuen Eröffnungsstoß durchführen oder den Gegner neu anstoßen lassen.
				create choice_state_.make_mode_titled (current, "Incorrect opening", "id", 3)
				choice_state_.button (1).set_text ("Continue playing with this board")
				choice_state_.button (1).actions.force (agent handle_continue)
				choice_state_.button (2).set_text ("Rebuild the table and start yourself")
				choice_state_.button (2).actions.force (agent handle_restart)
				choice_state_.button (3).set_text ("Rebuild the table and let opponent start")
				choice_state_.button (3).actions.force (agent handle_restart_other)
				Result := choice_state_
			elseif first_shot and then is_correct_opening (colls_) and then fallen_balls(colls_).has(white_number) and not fallen_balls (colls_).has(8) then
				-- rule 4.7
				-- white has fallen in a correct opening shot
--				 Der dann aufnahmeberechtigte Spieler hat Lageverbesserung im Kopffeld und darf keine Kugel direkt anspielen, 
				reset_state_ ?= ressources_.request_state( "8ball reset" )
				if reset_state_ = void then
					reset_state_ := create {Q_8BALL_RESET_STATE}.make_mode( current )
					ressources_.put_state( reset_state_ )
				end
				reset_state_.set_headfield (true)
				-- player can shot only out of headfield in next turn
				aim_state_ ?= ressources_.request_state ("8ball aim")
				aim_state_.set_out_of_headfield (true)
				switch_players
				is_open := true
				Result := reset_state_
			elseif first_shot and then is_correct_opening (colls_) and then fallen_balls (colls_).has(8) and not fallen_balls (colls_).has (white_number) then
				-- rule 4.9 first part
--				(1) Wird die "8" mit dem Eröffnungsstoß versenkt, so kann der eröffnende Spieler verlangen, daß
--				a) neu aufgebaut wird oder
--				b) die "8" wieder eingesetzt wird und er selbst so weiterspielt.
				create choice_state_.make_mode_titled (current, "Correct opening but has 8 fallen", "id", 2)
				choice_state_.button (1).set_text ("Rebuild the table and start yourself")
				choice_state_.button (1).actions.force (agent handle_restart)
				choice_state_.button (2).set_text ("Reset 8 and continue playing")
				choice_state_.button (2).actions.force (agent handle_set8_and_continue)
				is_open := true
				result := choice_state_
			elseif first_shot and then is_correct_opening (colls_) and then fallen_balls (colls_).has(8) and fallen_balls (colls_).has (white_number) then
--				-- rule 4.9 second part
--				(2) Fallen dem Spieler beim Eröffnungsstoß die Weiße und die "8", so kann der Gegner
--				a) neu aufbauen lassen oder
--				b) die "8" wieder einsetzen lassen und aus dem Kopffeld weiterspielen.
				create choice_state_.make_mode_titled (current,"Correct opening but 8 and white have fallen", "id",2)
				choice_state_.button (1).set_text ("Rebuild the table and start yourself")
				choice_state_.button (1).actions.force (agent handle_restart)
				choice_state_.button (2).set_text ("Set 8, reset white in headfield and continue playing")
				choice_state_.button (2).actions.force (agent handle_set8_and_continue_in_headfield)
				is_open := true
				result := choice_state_
			elseif not first_shot and then not is_correct_shot (colls_, active_player)  then
				-- rule 4.15
				-- the player made an incorrect shot during the game
--				(1) Der Gegner hat freie Lageverbesserung auf dem ganzen Tisch. 
				reset_state_ ?= ressources_.request_state( "8ball reset" )
				if reset_state_ = void then
					reset_state_ := create {Q_8BALL_RESET_STATE}.make_mode( current )
					ressources_.put_state( reset_state_ )
				end
				reset_state_.set_headfield (false)
				switch_players
				Result := reset_state_
			else
				
				-- ok, everything seems fine
				-- check if we can assign colors to players
				if is_open then
					close_table(fallen_balls (colls_).first)
					is_open := false
				end
				
				-- check if active player can play on black ball
				if my_balls_fallen then
					table.balls.item (8).add_owner (active_player)
				end
				-- set next state as bird state
				result := ressources_.request_state( "8ball bird" )
				if result = void then
					result := create {Q_8BALL_BIRD_STATE}.make_mode (Current)
					ressources_.put_state( result )
				end
				
				-- change players
				switch_players
			end
			
			first_shot := false
		end
		
feature {NONE} -- event handlers
	handle_continue(command_ :STRING; button_:Q_HUD_BUTTON) is
			-- next state is bird state, switch players and continue
		do
			
		end
	
	handle_restart(command_ :STRING; button_:Q_HUD_BUTTON) is
			-- next state is a new game in bird state
		do
			
		end
		
	handle_restart_other(command_ :STRING; button_:Q_HUD_BUTTON) is
			-- next state is a new game in bird state, switch players
		do
			handle_restart(command_, button_)
			switch_players
		end
		
	handle_set8_and_continue(command_:STRING; button_:Q_HUD_BUTTON) is
			-- next state is bird state, don't switch players
		do
			
		end
		
	handle_set8_and_continue_in_headfield(command_:STRING; button_:Q_HUD_BUTTON) is
			-- next state is reset state, don't switch players
		do
			
		end
		
	handle_main_menu(command_:STRING; button_:Q_HUD_BUTTON) is
			-- goto main menu, next state is escape state
		do
			
		end
		
		
feature {NONE} -- temporary ressources
	ressources: Q_GAME_RESSOURCES
		

feature -- Game Logic

	switch_players is
			-- the active player becomes non-active, the other one active
		do
			if active_player = player_a then
				active_player := player_b
			else
				active_player := player_a
			end
		end
		
	other_player : Q_PLAYER is
			-- the non-active player
		do
			if active_player = player_a then
				result := player_b
			else
				result := player_a
			end
		end
	
	valid_position( v_ : Q_VECTOR_2D ) : BOOLEAN is
		local 
			ball_already_there_ : BOOLEAN
			i_ : INTEGER
		do
			Result := true
			from
				i_ := table.balls.lower
			until
				i_ > table.balls.upper
			loop
				if (table.balls.item (i_).center - v_).length <= ball_radius then
					Result := false
				end
				i_ := i_+1
			end
			Result := Result and v_.x>=0 and v_.x<=width and v_.y >= 0 and v_.y <= height
		end
	
	reset_balls is
			-- reset the balls randomly
		do
			new_table
		end

	is_in_headfield(pos_ : Q_VECTOR_2D):BOOLEAN is
			-- is pos_ in the headfield?
		require
			pos_ /= void
		do
			Result := pos_.x < head_point.x
		end
		
		
	first_shot : BOOLEAN
	
	is_game_lost(collisions_: LIST[Q_COLLISION_EVENT]) : BOOLEAN is
			-- is the game lost
			-- 4.20 Verlust des Spiels
--				(1) Ein Spieler verliert das Spiel, wenn er
--				a) ein Foul spielt, während er die "8" versenkt (Ausnahme: siehe "8" fällt beim Eröffnungsstoß)
--				b) die "8" mit demselben Stoß versenkt, mit dem er die letzte Farbige versenkt
--				c) die "8" vom Tisch springen läßt
--				d) die "8" in eine andere als die angesagte Tasche versenkt
--				e) die "8" versenkt, bevor er berechtigt ist, darauf zu spielen.
		do
			
		end
		
	is_game_won(collisions_:LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- is the game won
		do
			
		end
		
	my_balls_fallen : BOOLEAN is
			-- are all balls of the active player's color fallen?
		do

		end
	
	close_table(ball_nr: INTEGER) is
			-- close the table, i.e. assign the active player to all balls with same colors as ball_nr
		require
			is_open
			ball_nr /= void
			ball_nr >0 and ball_nr <=15 and ball_nr /= 8
		local
			i: INTEGER
		do
			from
				i := table.balls.lower
			until
				i > table.balls.upper
			loop
				if table.balls.item(i).number <8 and ball_nr < 8 then
					-- same color
					table.balls.item (i).add_owner (active_player)
				else
					-- different color
					table.balls.item (i).add_owner (other_player)
				end
				i := i+1
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
			ball_fallen_ := not fallen_balls (collisions_).is_empty
			
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
			bank_shot_ : BOOLEAN
			ball_: Q_BALL
		do
			own_colored_first_ := false
			-- 4.12.1
			if collisions_.first.defendent.typeid = ball_type_id then
				ball_ ?= collisions_.first.defendent
				own_colored_first_ := ball_.owner.has(player_)
			end
			colored_ball_fallen_ := not fallen_balls (collisions_).is_empty and not fallen_balls (collisions_).has (white_number)
			any_bank_touched_ := not banks_touched (collisions_).is_empty
			-- 4.12.2
			-- white -> bank -> own_color -> (bank or color fallen)
			if collisions_.first.defendent.typeid = bank_type_id then
				if collisions_.i_th (2).defendent.typeid = ball_type_id then
					ball_ ?= collisions_.i_th (2).defendent
					if ball_.owner.has (active_player) and then (fallen_balls (collisions_).has (ball_.number) or else banks_touched (collisions_).count > 1) then
						bank_shot_ := true
					end
				end
				
			end
			Result := is_open implies (own_colored_first_ and then (colored_ball_fallen_ or else any_bank_touched_) or else bank_shot_)
		end
	
	is_open : BOOLEAN -- is the table "open", i.e. no colors yet specified
	
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
		
feature{NONE} -- set-up
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
			
			model_: Q_BALL_MODEL
			rand_: RANDOM
			axis_: Q_VECTOR_3D
		do
			create ball_models.make (0, 15)
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
		
		
	new_ai_player is
			-- creates/returns an AI-Player for this game mode
		do
		end
		

		



end -- class Q_8BALL
