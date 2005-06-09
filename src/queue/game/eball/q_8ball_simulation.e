indexing
	description: "Objects that call the physics engine and deal with the rules"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_SIMULATION_STATE

inherit
	Q_SIMULATION_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
		end
		
feature
	
	identifier : STRING is
		do
			Result := "8ball simulation"
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.info_hud )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.info_hud )
		end
		
	simulation_step (ressources_: Q_GAME_RESSOURCES): BOOLEAN is
			-- Makes one step of the physics. If the physics has done its job, false is
			-- returns. If the physics is still working, true is returned.
		do
			if not ressources_.simulation.has_finished then
				ressources_.simulation.step (ressources_.mode.table)
				Result := true
			else
				Result := false
			end
		end
		
	prepare_next_state (ressources_: Q_GAME_RESSOURCES): Q_GAME_STATE is
		-- what do to after physics has finished
		do
			-- ask the mode what to do according to result set
			Result := ressources_.mode.next_state (ressources_)
		end
		
feature{NONE}
	shot : Q_SHOT
	mode : Q_8BALL
	
end -- class Q_8BALL_SIMULATION
