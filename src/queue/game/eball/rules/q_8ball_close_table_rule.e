indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_CLOSE_TABLE_RULE

inherit
	Q_8BALL_RULE

create

	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball close table rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := mode.is_open and then not mode.first_shot and then is_correct_shot(colls_, mode.active_player)
		end

	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		do
				mode.close_table(mode.fallen_balls (ressources_.simulation.collision_list).first)
				-- set next state as bird state
				result := ressources_.request_state( "8ball bird" )
				if result = void then
					result := create {Q_8BALL_BIRD_STATE}.make_mode (mode)
					ressources_.put_state( result )
				end	
				-- change players
				mode.switch_players
		end
end -- class Q_8BALL_CLOSE_TABLE_RULE
