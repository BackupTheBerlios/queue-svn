indexing
	description: "The user can set the strength of the shot"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_ETH_SHOT_STATE

inherit
	Q_SHOT_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_ETH ) is
		do
			make
			mode := mode_
		end
		
	
feature
	
	identifier : STRING is
		do
			Result := "eth shot"
		end

	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.time_info_hud )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.time_info_hud )
		end

	prepare_next_state( pressure_ : DOUBLE; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Creates the next state. This involvs, saving the pressur.
			-- Returns void, if no next state should be choosen
			-- pressure_ : A value between slider.minimum and slider.maximum (default is 0 and 1).
			-- ressources_ : additional informations
		local
			simulation_state_ : Q_ETH_SIMULATION_STATE
		do
			-- set length of shot
			shot.direction.scale_to (pressure_)
			
			-- startup the simulation
			ressources_.simulation.new (ressources_.mode.table, shot)
			
			-- next state is simulation
			simulation_state_ ?= ressources_.request_state( "eth simulation" )
			if simulation_state_ = Void then
				create simulation_state_.make_mode( mode )
				ressources_.put_state( simulation_state_ )
			end
			simulation_state_.set_ball( shot.hitball )
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
	mode : Q_ETH
	
end -- class Q_8BALL_SHOT_STATE
