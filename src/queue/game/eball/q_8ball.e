indexing
	description: "This class implements the official 8-Ball billard game and rules (according to www.billardaire.de)"
	author: "Severin Hacker"

class
	Q_8BALL

inherit
	Q_ABSTRACT_MODE
	redefine
		active_player,
		install
	end
	
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
			
			-- create the ruleset
			create ruleset.make
			-- be careful order DOES matter, this is a kind of Zuständigkeitskette
			ruleset.force (create {Q_8BALL_LOST_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_WON_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_INCORRECT_OPENING_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_OPENING_WHITE_FALLEN_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_OPENING_BLACK_FALLEN_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_OPENING_BW_FALLEN_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_INCORRECT_SHOT_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_CLOSE_TABLE_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_PLAY_BLACK_RULE}.make_mode (current))
			ruleset.force (create {Q_8BALL_CORRECT_SHOT_AND_BALL_FALLEN_RULE}.make_mode(current))
			ruleset.force (create {Q_8BALL_CORRECT_SHOT_RULE}.make_mode(current))
			is_open := true
		end

		
feature	-- Interface
	player_A : Q_8BALL_PLAYER -- the first player
	player_B : Q_8BALL_PLAYER -- the second player
	active_player : Q_8BALL_PLAYER
	info_hud : Q_2_INFO_HUD -- the informations for the user
	
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
		

	human_player : Q_HUMAN_PLAYER is
			-- create a new human player for this game mode
		do
			result := create {Q_8BALL_HUMAN_PLAYER}.make_mode( current )
		end
	
	is_in_headfield(pos_ : Q_VECTOR_2D):BOOLEAN is
			-- is pos_ in the headfield?
		require
			pos_ /= void
		do
			Result := pos_.x < head_point.x
		end
		
	reset_balls is
			-- reset the balls randomly
		do
			new_table
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
		

feature -- game state features

	install(r_ : Q_GAME_RESSOURCES) is
		do
			precursor(r_)
			-- set first shot
			first_shot := true
		end
		
	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := player_a.first_state( ressources_ )
			active_player := player_a
			info_hud.set_left_active
		end
	
			
	next_state (ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- next state according to the ruleset
		local
			colls_ : LIST[Q_COLLISION_EVENT]
			finished_ : BOOLEAN
		do
			logger := ressources_.logger
			colls_ := ressources_.simulation.collision_list
			ressources_.logger.log("Q_8BALL","next_state", "fallen balls: "+fallen_balls (colls_).count.out)
			ressources_.logger.log("Q_8BALL","next_state","first shot: "+first_shot.out+"; is_open: "+is_open.out)
			ressources_.logger.log("Q_8BALL","next_state","correct shot: "+ruleset.first.is_correct_shot(colls_,active_player).out+"; is_correct_opening: "+ruleset.first.is_correct_opening(colls_).out)
			-- END DEBUG
			from
				ruleset.start	
			until
				ruleset.after or else finished_
			loop
				if ruleset.item.is_guard_satisfied (colls_) then
					-- DEBUG
					ressources_.logger.log("Q_8BALL","next_state",ruleset.item.identifier+ " is applicable")
					-- END DEBUG
					Result := ruleset.item.next_state (ressources_)
					finished_ := true
				end
				ruleset.forth
			end
			if not is_open then 
				assign_fallen_balls (colls_)
			end
			-- END DEBUG
			info_hud.set_small_left_text (player_a.fallen_balls.count.out)
			info_hud.set_small_right_text(player_b.fallen_balls.count.out)
			-- DEBUG
		end	

feature{Q_8BALL_RULE} -- 8ball state

		
	is_open : BOOLEAN -- is the table "open", i.e. no colors yet specified
	first_shot : BOOLEAN -- is this the first shot
	ruleset: LINKED_LIST[Q_8BALL_RULE]
	
	set_first_shot(b_ : BOOLEAN) is
			-- set the first shot flag
		do
			first_shot := b_
		end
		

	assign_fallen_balls(colls_: LIST[Q_COLLISION_EVENT]) is
		-- assign fallen balls to players
		local
			p_ : Q_8BALL_PLAYER
			fb_ : LINKED_LIST[INTEGER]
		do
			fb_ := fallen_balls (colls_)
			logger.log ("Q_8BALL","assign_fallen_balls","beginning")
			from
				fb_.start
			until
				fb_.after
			loop
				if fb_.item /= 8 and fb_.item /= white_number then
					logger.log ("Q_8BALL","assign_fallen_balls","assigning "+fb_.item.out+" to "+table.balls.item (fb_.item).owner.first.name)
					p_ ?= table.balls.item (fb_.item).owner.first
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
		
	other_player : Q_8BALL_PLAYER is
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
				x_ = width
--				or else valid_position (b_.center, b_)
			loop
				b_.set_center (create {Q_VECTOR_2D}.make (x_, head_point.y))
				x_ := x_ + 0.5
			end
		end
		
	close_table(ball_nr: INTEGER) is
			-- close the table, i.e. assign the active player to all balls with same color as ball_nr
		require
			is_open
			ball_nr /= void
			ball_nr >0 and ball_nr <=15 and ball_nr /= 8
		local
			i: INTEGER
		do
			-- DEBUG
			logger.log("Q_8BALL","close_table",active_player.name +" plays "+ball_nr.out)
			-- END DEBUG
			from
				i := table.balls.lower
			until
				i > table.balls.upper
			loop
				if (table.balls.item(i).number /= white_number) and (table.balls.item(i).number /= 8) then
					if (ball_nr < 8 and table.balls.item (i).number < 8) or else (ball_nr > 8 and table.balls.item (i).number > 8)  then
						-- same color
						table.balls.item (i).add_owner (active_player)
						logger.log("Q_8BALL","close_table", active_player.name+" becomes owner of "+table.balls.item(i).number.out)
					else
						-- different color
						table.balls.item (i).add_owner (other_player)
						logger.log("Q_8BALL","close_table", other_player.name+" becomes owner of "+table.balls.item(i).number.out)
					end
				end
				i := i+1
			end
			is_open := false
		end

feature -- helper functions

	ball_number_to_texture_name (number_: INTEGER):STRING is
			-- converts the ball number to the apropriate texture name
		do
			inspect number_
--				when  0 then result := "model/voll_00_weiss.png"
				when  0 then result := "model/halb_08_schwarz.png"
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
		
feature{Q_8BALL_RULE} -- temporary ressources
	logger :Q_LOGGER
	
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
			stretch
			link_table_and_balls
			read_ini_file
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
				when 14 then create result.make(head_point.x, head_point.y)
					
--				when 14 then create result.make(root_point.x+factor_*(2*ball_radius), root_point.y+ball_radius)
--				when 15 then create result.make(root_point.x, root_point.y)
				when 15 then create result.make(20,20)
					
			end
		end
		
	new_ai_player is
			-- creates/returns an AI-Player for this game mode
		do
		end

end -- class Q_8BALL
