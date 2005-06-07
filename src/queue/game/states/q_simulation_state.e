indexing
	description: "A mode where the user cannot interact with the system, he can change the camera, but not more"
	author: "Benjamin Sigg"

deferred class
	Q_SIMULATION_STATE

inherit
	Q_ESCAPABLE_STATE

feature{NONE} -- creation
	make is
		do
			create behaviour.make
		end

feature{NONE} -- values
	behaviour : Q_FREE_CAMERA_BEHAVIOUR

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_camera_behaviour( behaviour )
		end
	
	uninstall(ressources_: Q_GAME_RESSOURCES ) is
		do
			ressources_.gl_manager.set_camera_behaviour( void )
		end
	
	step( ressources_ : Q_GAME_RESSOURCES ) is
		do
			if next_state = void then
				if not simulation_step( ressources_ ) then
					set_next_state( prepare_next_state( ressources_ ))
				end
			end
		end
		
	
	simulation_step( ressources_ : Q_GAME_RESSOURCES ) : BOOLEAN is
			-- Makes one step of the physics. If the physics has done its job, false is
			-- returns. If the physics is still working, true is returned.
		deferred
		end
		
	prepare_next_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Is invoked, after the physics has done its job (no ball is moving)
			-- If you don't want to change into a new state, return void.
		deferred
		end
		
end -- class Q_SIMULATION_STATE
