indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_CORRECT_SHOT_AND_BALL_FALLEN_RULE

inherit
	Q_8BALL_RULE
	
create
	make_mode
	
feature -- rule
	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball correct shot and ball fallen rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := (not (mode.fallen_balls(colls_).count =0)) and then (mode.first_shot and is_correct_opening(colls_)) or else (not mode.first_shot and then is_correct_shot(colls_, mode.active_player))
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		do
				mode.set_first_shot (false)
				-- set next state as bird state
				result := ressources_.request_state( "8ball bird" )
				if result = void then
					result := create {Q_8BALL_BIRD_STATE}.make_mode (mode)
					ressources_.put_state( result )
				end
		end


end -- class Q_8BALL_CORRECT_SHOT_AND_BALL_FALLEN_RULE
