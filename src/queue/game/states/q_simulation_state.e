indexing
	description: "A mode where the user cannot interact with the system, he can change the camera, but not more"
	author: "Benjamin Sigg"

deferred class
	Q_SIMULATION_STATE

inherit
	Q_ESCAPABLE_STATE
	redefine
		step
	end

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
	
end -- class Q_SIMULATION_STATE
