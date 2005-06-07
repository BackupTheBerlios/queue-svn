indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_SHOT_STATE

inherit
	Q_SHOT_STATE
	
creation
	make
	
feature
	
	identifier : STRING is
		do
			Result := "8ball shot"
		end
		
	prepare_next_state( pressure_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Creates the next state. This involvs, saving the pressur.
			-- Returns void, if no next state should be choosen
			-- pressure_ : A value between slider.minimum and slider.maximum (default is 0 and 1).
			-- ressources_ : additional informations
		local
			simulation_state_ : Q_8BALL_SIMULATION_STATE
		do
			-- set length of shot
			shot.direction.scale_to (pressure_)
			
			-- next state is simulation
			simulation_state_ ?= ressources_.request_state( "8ball simulation" )
			if simulation_state_ = Void then
				create simulation_state_.make
				ressources_.put_state( simulation_state_ )
			end
			simulation_state_.set_shot( shot)
			result := simulation_state_
		end
		
	set_shot(shot_:Q_SHOT) is
		require
			shot_ /= void
		do
			shot := shot_
		end
		
feature {NONE}
	shot: Q_SHOT
	
end -- class Q_8BALL_SHOT_STATE
