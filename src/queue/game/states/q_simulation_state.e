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
		end

feature{NONE} -- values
	free_behaviour : Q_FREE_CAMERA_BEHAVIOUR
	ball_behaviour : Q_BALL_CAMERA_BEHAVIOUR

feature
	install( ressources_: Q_GAME_RESSOURCES ) is
		do
			if ressources_.follow_on_shot then
				if ball_behaviour = void then
					create ball_behaviour.make( ressources_ )
				end
				
				ball_behaviour.set_ball( ball )
				ball_behaviour.calculate_from( ressources_.gl_manager.camera )
				ressources_.gl_manager.set_camera_behaviour( ball_behaviour )
			else
				if free_behaviour = void then
					create free_behaviour.make
				end
				
				ressources_.gl_manager.set_camera_behaviour( free_behaviour )
			end
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
		
feature -- ball
	ball : Q_BALL
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
		
		
end -- class Q_SIMULATION_STATE
