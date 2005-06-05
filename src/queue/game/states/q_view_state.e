indexing
	description: "Objects that represent the View Mode for human-user-interaction. User can fly over the table and look at the situation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_BIRD_STATE

inherit
	Q_ESCAPABLE_STATE
	
creation
	make
	
feature{NONE}
	make is
		do
			create behaviour.make
		end
		
feature{NONE} -- values
	behaviour : Q_FREE_CAMERA_BEHAVIOUR
	
feature -- from Q_GAME_STATE
	install( ressources_ : Q_GAME_RESSOURCES ) is
		-- Installs this mode. For example, the mode can add
		-- a speciall button to the hud
		do
			ressources_.gl_manager.set_camera_behaviour( behaviour )
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		-- Uninstalls this mode. For example, if the mode
		-- did add a button to the hud, it must now 
		-- remove this button.
		do
			ressources_.gl_manager.set_camera_behaviour( void )
		end
	
	identifier : STRING is
		-- A String witch is used as unique identifier for this state
		-- The string should contain the name of the class, without the "q_"
		-- and withoud a "state", and only lower-case characters
		-- Example: Q_VIEW_STATE will return "view"
		do
			result := "bird state"
		end

end -- class Q_VIEW_STATE
