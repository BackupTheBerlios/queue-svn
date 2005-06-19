indexing
	description: "Player made an incorrect shot, other player can set the white ball"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_INCORRECT_SHOT_RULE

inherit
	Q_8BALL_RULE
	Q_CONSTANTS

create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball incorrect shot rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := not mode.first_shot and then not is_correct_shot (colls_, mode.active_player)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- rule 4.15
			-- the player made an incorrect shot during the game
			--(1) Der Gegner hat freie Lageverbesserung auf dem ganzen Tisch. 
		local
			reset_state_ : Q_8BALL_RESET_STATE
		do
				reset_state_ ?= ressources_.request_state( "8ball reset" )
				if reset_state_ = void then
					reset_state_ := create {Q_8BALL_RESET_STATE}.make_mode( mode )
					ressources_.put_state( reset_state_ )
				end
				reset_state_.set_ball (ressources_.mode.table.balls.item(white_number))
				reset_state_.set_headfield (false)
				mode.switch_players
				Result := reset_state_
		end
		
		
end -- class Q_8BALL_INCORRECT_SHOT_RULE
