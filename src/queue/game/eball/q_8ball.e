indexing
	description: "This class implements the official 8-Ball billard game and rules (according to www.billardaire.de)"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL

inherit
	Q_MODE
	redefine
		active_player
	end
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

			create ball_updater.make( current )
			
			-- create hud
			create info_hud.make_ordered( true )
			info_hud.set_location( 0.05, 0.75 )
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
			create ini_file.make_open_read ("data/8ball.ini")
			
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
		
feature	-- Interface
	light_one, light_two : Q_GL_LIGHT	
	table : Q_TABLE	
	table_model: Q_TABLE_MODEL
	ball_models: ARRAY[Q_BALL_MODEL]
	player_A : Q_8BALL_PLAYER -- the first player
	player_B : Q_8BALL_PLAYER -- the second player
	active_player : Q_8BALL_PLAYER
	info_hud : Q_2_INFO_HUD -- the informations for the user
	ball_updater : Q_BALL_POSITION_UPDATER
	
	set_player_a( player_ : Q_PLAYER ) is
		do
			player_a ?= player_
			info_hud.set_big_left_text( player_.name )
		end
	
	set_player_b( player_ : Q_PLAYER ) is
		do
			player_b ?= player_
			info_hud.set_big_right_text( player_.name )
		end

	ai_player : Q_AI_PLAYER is
		do
			result := create {Q_8BALL_NAIVE_AI_PLAYER}.make
		end
		
	reset_balls is
			-- reset the balls randomly
		do
			new_table
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
		
	valid_position(sim_:Q_SIMULATION; v_ : Q_VECTOR_2D; ball_ : Q_BALL ) : BOOLEAN is
			-- is v_ a valid position, no ball in environment, not in bank, etc.
		do
			Result := not sim_.collision_detector.collision_test
		end
	
	is_in_headfield(pos_ : Q_VECTOR_2D):BOOLEAN is
			-- is pos_ in the headfield?
		require
			pos_ /= void
		do
			Result := pos_.x < head_point.x
		end
		

	identifier : STRING is
		do
			result := "8ball"
		end
		
	number_of_balls : INTEGER is
		-- the total number of colored balls in 8ball
		do
			Result := 15 
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
			-- converts the ball number to the apropriate texture name
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
		
			
	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := player_a.first_state( ressources_ )
			active_player := player_a
		end
	
			
	next_state (ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- next state according to the ruleset
		local
			reset_state_ : Q_8BALL_RESET_STATE
			aim_state_ : Q_8BALL_AIM_STATE
			choice_state_ : Q_8BALL_CHOICE_STATE
			colls_ : LIST[Q_COLLISION_EVENT]
			fb_: LIST[INTEGER]
		do
			ressources := ressources_
			colls_ := ressources_.simulation.collision_list
			fb_ := fallen_balls (colls_)
			if is_game_lost(colls_) then
				choice_state_ ?= ressources.request_state ("8ball lost")
				if choice_state_ = void then
					create choice_state_.make_mode_titled( current, active_player.name+" loses", "8ball lost", 2)
					choice_state_.button (1).set_text ("Play again")
					choice_state_.button (1).actions.force (agent handle_restart(?,?,choice_state_))
					choice_state_.button (2).set_text ("Main menu")
					choice_state_.button (2).actions.force (agent handle_main_menu(?,?,choice_state_))
				end
				choice_state_.set_title(active_player.name+" loses")
				Result := choice_state_
			elseif is_game_won(colls_) then
				choice_state_ ?= ressources.request_state("8ball won")
				if choice_state_ = void then
					create choice_state_.make_mode_titled (current, active_player.name+" wins", "8ball won", 2)
					choice_state_.button (1).set_text ("Play again")
					choice_state_.button (1).actions.force (agent handle_restart(?,?,choice_state_))
					choice_state_.button (2).set_text ("Main menu")
					choice_state_.button (2).actions.force (agent handle_main_menu(?,?,choice_state_))
				end
				choice_state_.set_title (active_player.name+" wins")
				Result := choice_state_
			elseif first_shot and then not is_correct_opening (colls_) then
				-- rule 4.6 second part
--				-- the current player made an error, the other player can
--				a) die Position so �bernehmen und weiterspielen oder
--				b) die Kugeln neu aufbauen lassen und selbst einen neuen Er�ffnungssto� durchf�hren oder den Gegner neu ansto�en lassen.
				choice_state_ ?= ressources.request_state ("8ball incorrect opening")
				if choice_state_ = void then
					create choice_state_.make_mode_titled (current, "Incorrect opening", "8ball incorrect opening", 3)
					choice_state_.button (1).set_text ("Continue playing with this board")
					choice_state_.button (1).actions.force (agent handle_continue(?,?,choice_state_))
					choice_state_.button (2).set_text ("Rebuild the table and start yourself")
					choice_state_.button (2).actions.force (agent handle_restart (?,?,choice_state_))
					choice_state_.button (3).set_text ("Rebuild the table and let opponent start")
					choice_state_.button (3).actions.force (agent handle_restart_other (?,?,choice_state_))	
				end
				Result := choice_state_
			elseif first_shot and then is_correct_opening (colls_) and then fb_.has(white_number) and not fb_.has(8) then
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
			elseif first_shot and then is_correct_opening (colls_) and then fb_.has(8) and not fb_.has (white_number) then
				-- rule 4.9 first part
--				(1) Wird die "8" mit dem Er�ffnungssto� versenkt, so kann der er�ffnende Spieler verlangen, da�
--				a) neu aufgebaut wird oder
--				b) die "8" wieder eingesetzt wird und er selbst so weiterspielt.
				choice_state_ ?= ressources.request_state ("8ball 8 fallen")
				if choice_state_ = void then
					create choice_state_.make_mode_titled (current, "Correct opening but has 8 fallen", "8ball 8 fallen", 2)
					choice_state_.button (1).set_text ("Rebuild the table and start yourself")
					choice_state_.button (1).actions.force (agent handle_restart)
					choice_state_.button (2).set_text ("Reset 8 and continue playing")
					choice_state_.button (2).actions.force (agent handle_set8_and_continue)
					is_open := true	
				end
				result := choice_state_
			elseif first_shot and then is_correct_opening (colls_) and then fb_.has(8) and fb_.has (white_number) then
--				-- rule 4.9 second part
--				(2) Fallen dem Spieler beim Er�ffnungssto� die Wei�e und die "8", so kann der Gegner
--				a) neu aufbauen lassen oder
--				b) die "8" wieder einsetzen lassen und aus dem Kopffeld weiterspielen.
				choice_state_ ?= ressources.request_state ("8ball 8 and white fallen")
				if choice_state_ = void then
					create choice_state_.make_mode_titled (current,"Correct opening but 8 and white have fallen", "8ball 8 and white fallen",2)
					choice_state_.button (1).set_text ("Rebuild the table and start yourself")
					choice_state_.button (1).actions.force (agent handle_restart)
					choice_state_.button (2).set_text ("Set 8, reset white in headfield and continue playing")
					choice_state_.button (2).actions.force (agent handle_set8_and_continue_in_headfield)
					is_open := true
				end
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
				if all_balls_fallen then
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
			assign_fallen_balls (fb_)
		end
		
feature {NONE} -- event handlers
	handle_continue(command_ :STRING; button_:Q_HUD_BUTTON;cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is bird state, switch players and continue
		local
			ns_ : Q_8BALL_BIRD_STATE
		do
			ns_ ?= ressources.request_state ("8ball bird")
			if ns_ = void then
				create ns_.make_mode (current)
				ressources.put_state (ns_)
			end
			switch_players
			cs_.set_next_state (ns_)
		end
	
	handle_restart(command_ :STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is a new game in bird state
		local
			ns_ : Q_8BALL_BIRD_STATE
		do
			ns_ ?= ressources.request_state ("8ball bird")
			if ns_ = void then
				create ns_.make_mode (current)
				ressources.put_state (ns_)
			end
			reset_balls
			cs_.set_next_state (ns_)
		end
		
	handle_restart_other(command_ :STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is a new game in bird state, switch players
		do
			handle_restart(command_, button_,cs_)
			switch_players
		end
		
	handle_set8_and_continue(command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is bird state, don't switch players
		local
			ns_: Q_8BALL_BIRD_STATE
		do
			ns_ ?= ressources.request_state ("8ball bird")
			if ns_ = void then
				create ns_.make_mode (current)
				ressources.put_state (ns_)
			end
			insert_ball(table.balls.item (8))
			cs_.set_next_state (ns_)
		end
		
	handle_set8_and_continue_in_headfield(command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is reset state, don't switch players
		local
			ns_: Q_8BALL_RESET_STATE
		do
			ns_ ?= ressources.request_state ("8ball reset")
			if ns_ = void then
				create ns_.make_mode (current)
				ressources.put_state (ns_)
			end
			ns_.set_headfield (true)
			insert_ball (table.balls.item (8))
			cs_.set_next_state (ns_)
		end
		
	handle_main_menu(command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- goto main menu, next state is escape state
		local
			ns_: Q_ESCAPE_STATE
		do
			ns_ ?= ressources.request_state ("escape")
			if ns_ = void then
				create ns_.make (false)
				ressources.put_state (ns_)
			end
			cs_.set_next_state (ns_)
		end
		
		
feature {NONE} -- temporary ressources
	ressources: Q_GAME_RESSOURCES
		

feature{NONE} -- Game Logic
	is_game_lost(colls_: LIST[Q_COLLISION_EVENT]) : BOOLEAN is
			-- is the game lost
			-- 4.20 Verlust des Spiels
--				(1) Ein Spieler verliert das Spiel, wenn er
--				a) ein Foul spielt, w�hrend er die "8" versenkt (Ausnahme: siehe "8" f�llt beim Er�ffnungssto�)
--				b) die "8" mit demselben Sto� versenkt, mit dem er die letzte Farbige versenkt
--				c) die "8" vom Tisch springen l��t
--				d) die "8" in eine andere als die angesagte Tasche versenkt
--				e) die "8" versenkt, bevor er berechtigt ist, darauf zu spielen.
		local
			foul_8, last_8, too_early_8: BOOLEAN
			i : INTEGER
		do
			foul_8 := fallen_balls (colls_).has (8) and not is_correct_shot (colls_,active_player)
			from
				i := 1
			until
				i > 15
			loop
				last_8 := last_8 or (fallen_balls (colls_).has (i) and table.balls.item (i).owner.has (active_player))
				i := i+1
			end
			last_8 := last_8 and fallen_balls (colls_).has (8)
			too_early_8 := not all_balls_fallen and fallen_balls (colls_).has (8)
			Result := foul_8 or last_8 or too_early_8
		end
		
	is_game_won(collisions_:LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- is the game won
		do
			Result := all_balls_fallen and fallen_balls (collisions_).has (8)
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

	all_balls_fallen : BOOLEAN is
			-- are all balls of the active player's color fallen? (but not 8)
		do
			Result := active_player.fallen_balls.count = 7
		end

	assign_fallen_balls(fb_: LIST[INTEGER]) is
		-- assign fallen balls to players
		local
			p_ : Q_8BALL_PLAYER
		do
			from
				fb_.start
			until
				fb_.after
			loop
				if fb_.item /= 8 and fb_.item /= white_number then
					p_ ?= table.balls.item (fb_.item).owner
					p_.fallen_balls.force (table.balls.item(fb_.item))
				end
				fb_.forth
			end
		end
			
	switch_players is
			-- the active player becomes non-active, the other one active
		do
			if active_player = player_a then
				active_player := player_b
				info_hud.set_right_active
			else
				active_player := player_a
				info_hud.set_left_active
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
		
	insert_ball(b_ : Q_BALL) is
			-- insert a ball on the fusspunkt or a position nearby
		local
			x_: DOUBLE
		do
			from
				x_ := head_point.x
				b_.set_center (head_point)
			until
				x_ = width or else valid_position (ressources.simulation, b_.center, b_)
			loop
				b_.set_center (create {Q_VECTOR_2D}.make (x_, head_point.y))
				x_ := x_ + 0.5
			end
		end
		
	first_shot : BOOLEAN
	
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
			
			link_table_and_balls
			
			read_ini_file
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
		
		
	new_ai_player is
			-- creates/returns an AI-Player for this game mode
		do
		end

end -- class Q_8BALL

