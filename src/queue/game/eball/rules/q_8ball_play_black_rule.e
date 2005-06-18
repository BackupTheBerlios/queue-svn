indexing
	description: "The active player has shot all balls of his color and can now play on the black ball"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_PLAY_BLACK_RULE

inherit
	Q_8BALL_RULE
	
create

	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball play black rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := all_balls_fallen
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		do
				mode.table.balls.item (8).add_owner (mode.active_player)
				-- set next state as bird state
				result := ressources_.request_state( "8ball bird" )
				if result = void then
					result := create {Q_8BALL_BIRD_STATE}.make_mode (mode)
					ressources_.put_state( result )
				end	
				-- change players
				mode.switch_players
		end

end -- class Q_8BALL_PLAY_BLACK_RULE
