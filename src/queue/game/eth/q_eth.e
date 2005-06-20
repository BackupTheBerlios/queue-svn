indexing
	description: "The ETH mode is a single player mode. The starting table is an ETH logo written with balls. "
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_ETH

inherit
	Q_ABSTRACT_MODE
	redefine
		active_player, install
	end
	Q_CONSTANTS

creation
	make
	
feature -- Interface

	make is
			-- create an eth mode
		do
			-- create the ball_models
			new_ball_models
			-- create the model and the table
			new_table_model
			new_table
			create ball_updater.make( current )
			
			-- create hud
			create time_info_hud.make
			time_info_hud.set_location( 0.05, 0.75 )
			time_info_hud.set_time_max (150000*60)
			time_info_hud.set_time_cuts (15)
			time_info_hud.stop
		end
		
	identifier :STRING is "eth"	
	
	number_of_balls : INTEGER is 28
	
	set_player(p_: Q_PLAYER) is
			-- don't change the info hud
		do
			active_player ?= p_
			time_info_hud.set_big_text (p_.name)
		end
	
	active_player: Q_ETH_PLAYER
	
	human_player : Q_HUMAN_PLAYER is
			-- an eth human player
		do
			Result := create {Q_ETH_HUMAN_PLAYER}.make_mode (current)
		end
		
	ai_player : Q_AI_PLAYER is
			-- an eth ai player
		do
			result := void
		end
	
	restart is
			-- reset the balls randomly and restart the timer
		do
			new_table
			active_player.fallen_balls.wipe_out
			time_info_hud.stop
			time_info_hud.set_small_text ("0")
			time_info_hud.set_time( 0 )
		end

feature -- hud
	time_info_hud: Q_TIME_INFO_HUD
		
feature{NONE} -- agent handlers

	handle_restart(r_:Q_GAME_RESSOURCES; command_ :STRING; button_:Q_HUD_BUTTON; cs_: Q_ETH_CHOICE_STATE) is
			-- next state is a new game in bird state
		local
			ns_ : Q_ETH_RESET_STATE
		do
			restart
			cs_.set_next_state (first_state (r_))
		end
		
	handle_main_menu(r_:Q_GAME_RESSOURCES; command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_ETH_CHOICE_STATE) is
			-- goto main menu, next state is escape state
		local
			ns_: Q_ESCAPE_STATE
		do
			ns_ ?= r_.request_state ("escape")
			if ns_ = void then
				create ns_.make (false)
				r_.put_state (ns_)
			end
			cs_.set_next_state (ns_)
		end
		
feature {NONE} -- setup
	
	new_table is
			-- create an eth table
		local
			balls_: ARRAY[Q_BALL]
			ball_ : Q_BALL
			nr : INTEGER
			rand_ : Q_RANDOM
			used_integers : LINKED_LIST[INTEGER]
		do
			create rand_
			-- build positions
			create used_integers.make
			
			-- create the balls
			create balls_.make (0,28)
			
			-- create the white ball
			create ball_.make_empty
			ball_.set_radius (ball_radius)
			ball_.set_number (white_number)
			ball_.set_center (head_point)
			balls_.force (ball_,white_number)
			
			-- create the rest of the balls
			from
				nr := 1
			until
				nr > 28
			loop
				ball_ := ball_.deep_twin				
				ball_.set_number (nr)
				ball_.set_center (eth_position (nr))
				balls_.force (ball_,nr)
				nr := nr +1
			end
			table := void
			create table.make (balls_, table_model.banks, table_model.holes)
			link_table_and_balls
			stretch
			read_ini_file
		end
		
	ball_number_to_texture_name (number_: INTEGER):STRING is
			-- convertes the ball number to the apropriate texture name
		do
			inspect number_
				when  0 then result := "model/halb_10_blau.png"
				else  
					result := "model/halb_14_gruen.png"
			end
		
		end
		
	eth_position(nr_:INTEGER):Q_VECTOR_2D is
			-- give a position in the ETH created by balls
		do
			inspect nr_
			when 1 then create result.make (root_point.x+8*ball_radius, root_point.y-8*ball_radius)
			when 2 then create result.make (root_point.x+8*ball_radius, root_point.y-6*ball_radius)
			when 3 then create result.make (root_point.x+8*ball_radius, root_point.y-4*ball_radius)
			when 4 then create result.make (root_point.x+8*ball_radius, root_point.y-2*ball_radius)
			when 5 then create result.make (root_point.x+8*ball_radius, root_point.y)
			when 6 then create result.make (root_point.x+8*ball_radius, root_point.y+2*ball_radius)
			when 7 then create result.make (root_point.x+8*ball_radius, root_point.y+4*ball_radius)
			when 8 then create result.make (root_point.x+8*ball_radius, root_point.y+8*ball_radius)
			when 9 then create result.make (root_point.x+6*ball_radius, root_point.y-8*ball_radius)
			when 10 then create result.make (root_point.x+6*ball_radius, root_point.y)
			when 11 then create result.make (root_point.x+6*ball_radius, root_point.y+4*ball_radius)
			when 12 then create result.make (root_point.x+6*ball_radius, root_point.y+8*ball_radius)
			when 13 then create result.make (root_point.x+4*ball_radius, root_point.y-8*ball_radius)
			when 14 then create result.make (root_point.x+4*ball_radius, root_point.y-6*ball_radius)
			when 15 then create result.make (root_point.x+4*ball_radius, root_point.y)
			when 16 then create result.make (root_point.x+4*ball_radius, root_point.y+4*ball_radius)
			when 17 then create result.make (root_point.x+4*ball_radius, root_point.y+6*ball_radius)
			when 18 then create result.make (root_point.x+4*ball_radius, root_point.y+8*ball_radius)
			when 19 then create result.make (root_point.x+2*ball_radius, root_point.y-8*ball_radius)
			when 20 then create result.make (root_point.x+2*ball_radius, root_point.y)
			when 21 then create result.make (root_point.x+2*ball_radius, root_point.y+4*ball_radius)
			when 22 then create result.make (root_point.x+2*ball_radius, root_point.y+8*ball_radius)
			when 23 then create result.make (root_point.x, root_point.y-8*ball_radius)
			when 24 then create result.make (root_point.x, root_point.y-6*ball_radius)
			when 25 then create result.make (root_point.x, root_point.y-4*ball_radius)
			when 26 then create result.make (root_point.x, root_point.y)
--			when 27 then create result.make (head_point.x,head_point.y)
			when 27 then create result.make (root_point.x, root_point.y+4*ball_radius)
			when 28 then create result.make (root_point.x, root_point.y+8*ball_radius)
--			when 28 then create result.make (30, 30)
			
			end
		end
		
feature -- game state

	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			time_info_hud.stop
			time_info_hud.set_time( 0 )
			time_info_hud.set_wait( true )
		end
		

	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := active_player.first_state( ressources_ )
		end
	
		
	next_state (ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- next state according to ruleset. If there is still time to play and there are balls on the table next state is bird state else statistics screen
		local
			fb_: LIST[INTEGER]
			colls_ : LIST[Q_COLLISION_EVENT]
			choice_state_ : Q_ETH_CHOICE_STATE
		do
			colls_ := ressources_.simulation.collision_list
			fb_ := fallen_balls (colls_)
			assign_fallen_balls (fb_)
			-- DEBUG
			ressources_.logger.log("Q_ETH","next_state",fb_.count.out+" balls have fallen")
			-- END DEBUG
			if is_lost(colls_) then
				choice_state_ ?= ressources_.request_state ("eth lost")
				if choice_state_ = void then
					create choice_state_.make_mode_titled( current,"Time is up "+ active_player.name+" loses", "eth lost", 2)
					choice_state_.button (1).set_text ("Play again")
					choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
					choice_state_.button (2).set_text ("Main menu")
					choice_state_.button (2).actions.force (agent handle_main_menu(ressources_,?,?,choice_state_))
				end
				choice_state_.set_title(active_player.name+" loses")
				Result := choice_state_
			elseif is_won then
				choice_state_ ?= ressources_.request_state("eth won")
				if choice_state_ = void then
					create choice_state_.make_mode_titled (current,"Congratulation, "+ active_player.name+" wins", "eth won", 2)
					choice_state_.button (1).set_text ("Play again")
					choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
					choice_state_.button (2).set_text ("Main menu")
					choice_state_.button (2).actions.force (agent handle_main_menu(ressources_,?,?,choice_state_))
				end
				choice_state_.set_title ("Congratulation, "+ active_player.name+" wins")
				Result := choice_state_
			else
				result := ressources_.request_state( "eth bird" )
				if result = void then
					result := create {Q_ETH_BIRD_STATE}.make_mode (Current)
					ressources_.put_state( result )
				end	
			end
			time_info_hud.set_small_text (active_player.fallen_balls.count.out)
		end
		

feature{NONE} -- game logic

	assign_fallen_balls(fb_: LIST[INTEGER]) is
		-- assign fallen balls to players
		do
			from
				fb_.start
			until
				fb_.after
			loop
				if fb_.item /= white_number then
					active_player.fallen_balls.force ((table.balls.item(fb_.item)))
				end
				fb_.forth
			end
		end
		
	is_won :BOOLEAN is
			-- have all balls fallen?
		do
			Result := active_player.fallen_balls.count = 28
		end
		
	is_lost (colls_:LIST[Q_COLLISION_EVENT]):BOOLEAN is
			-- is time up?
		do
			Result := fallen_balls (colls_).has (0) or else time_info_hud.over
		end
	
end -- class Q_ETH
