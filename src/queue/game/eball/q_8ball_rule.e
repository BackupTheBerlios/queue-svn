indexing
	description: "The general notion of a rule with guard and action"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_8BALL_RULE

inherit
	Q_CONSTANTS
	

feature	-- interface 
	is_guard_satisfied(c_: LIST[Q_COLLISION_EVENT]) :BOOLEAN is
			-- is this rule allowed to be executed?
		deferred
		end
		
	next_state(r_:Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- change game state via mode if necessary and decide what to do next?
		deferred
		end
		
	identifier : STRING is
			-- the name of the rule
		deferred
		end
		
		
feature -- common game logic

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
			if not collisions_.is_empty and then collisions_.first.defendent.typeid = ball_type_id then
				ball_ ?= collisions_.first.defendent
				own_colored_first_ := ball_.owner.has(player_) or else mode.is_open
			end
			colored_ball_fallen_ := not mode.fallen_balls (collisions_).is_empty and not mode.fallen_balls (collisions_).has (white_number)
			any_bank_touched_ := not mode.banks_touched (collisions_).is_empty
			-- 4.12.2
			-- white -> bank -> own_color -> (bank or color fallen)
			if collisions_.count >=2 and then collisions_.first.defendent.typeid = bank_type_id then
				if collisions_.i_th (2).defendent.typeid = ball_type_id then
					ball_ ?= collisions_.i_th (2).defendent
					if ball_.owner.has (mode.active_player) and then (mode.fallen_balls (collisions_).has (ball_.number) or else mode.banks_touched (collisions_).count > 1) then
						bank_shot_ := true
					end
				end
				
			end
			--DEBUG
			mode.logger.log ("Q_8BALL_RULE","is_correct_shot","own_colored_first_ :"+own_colored_first_.out +", colored_ball_fallen_: "+colored_ball_fallen_.out+", any_bank_touched_: "+any_bank_touched_.out+", bank_shot_: "+bank_shot_.out)
			--END DEBUG
			Result :=  (own_colored_first_ and then (colored_ball_fallen_ or else any_bank_touched_) or else bank_shot_)
		end
		
	is_correct_opening(collisions_: LIST[Q_COLLISION_EVENT]):BOOLEAN is
			-- this implements rule 4.6 for a correct opening, the definition
		local
			ball_fallen_, four_balls_: BOOLEAN
			touched_balls_: LINKED_LIST[INTEGER]
			ball_ : Q_BALL
			
		do
			-- (a) a ball has fallen into a hole
			ball_fallen_ := not mode.fallen_balls (collisions_).is_empty
			
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

	is_game_won(collisions_:LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- is the game won
		do
			Result := all_balls_fallen and mode.fallen_balls (collisions_).has (8)
		end
		
	
	all_balls_fallen : BOOLEAN is
			-- are all balls of the active player's color fallen? (but not 8)
		do
			Result := mode.active_player.fallen_balls.count = 7
		end
feature{Q_8BALL_RULE} -- event handlers

	handle_continue(r_: Q_GAME_RESSOURCES; command_ :STRING; button_:Q_HUD_BUTTON;cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is bird state, switch players and continue
		local
			ns_ : Q_8BALL_BIRD_STATE
		do
			ns_ ?= r_.request_state ("8ball bird")
			if ns_ = void then
				create ns_.make_mode (mode)
				r_.put_state (ns_)
			end
			mode.set_first_shot (false)
			mode.switch_players
			cs_.set_next_state (ns_)
		end
	
	handle_restart(r_: Q_GAME_RESSOURCES; command_ :STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is a new game in bird state
		local
			ns_ : Q_8BALL_RESET_STATE
		do
			ns_ ?= r_.request_state ("8ball reset")
			if ns_ = void then
				create ns_.make_mode (mode)
				r_.put_state (ns_)
			end
			mode.reset_balls
			ns_.set_ball (mode.table.balls.item (white_number))
			cs_.set_next_state (ns_)
		end
		
	handle_restart_other(r_: Q_GAME_RESSOURCES; command_ :STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is a new game in bird state, switch players
		do
			handle_restart(r_,command_, button_,cs_)
			mode.switch_players
		end
		
	handle_set8_and_continue(r_: Q_GAME_RESSOURCES; command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is bird state, don't switch players
		local
			ns_: Q_8BALL_BIRD_STATE
		do
			ns_ ?= r_.request_state ("8ball bird")
			if ns_ = void then
				create ns_.make_mode (mode)
				r_.put_state (ns_)
			end
			mode.insert_ball(mode.table.balls.item (8))
			cs_.set_next_state (ns_)
		end
		
	handle_set8_and_continue_in_headfield(r_: Q_GAME_RESSOURCES;command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
			-- next state is reset state, don't switch players
		local
			ns_: Q_8BALL_RESET_STATE
		do
			ns_ ?= r_.request_state ("8ball reset")
			if ns_ = void then
				create ns_.make_mode (mode)
				r_.put_state (ns_)
			end
			ns_.set_ball (mode.table.balls.item (white_number))
			ns_.set_headfield (true)
			mode.insert_ball (mode.table.balls.item (8))
			cs_.set_next_state (ns_)
		end
		
	handle_main_menu(r_:Q_GAME_RESSOURCES;command_:STRING; button_:Q_HUD_BUTTON; cs_: Q_8BALL_CHOICE_STATE) is
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
	
feature {NONE}
	mode: Q_8BALL
	
end -- class Q_8BALL_RULE
