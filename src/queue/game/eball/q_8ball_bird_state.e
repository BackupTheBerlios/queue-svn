indexing
	description: "This state allows to look around and do nothing."
	author: "Benjamin Sigg"

class
	Q_8BALL_BIRD_STATE

inherit
	Q_BIRD_STATE
	redefine
		identifier,
		default_next_state,
		install
	end

creation
	make_mode
	
feature{NONE} -- creation
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
		end
	
	mode : Q_8BALL
	
feature
	install( ressources_ : Q_GAME_RESSOURCES ) is
		-- Installs this mode. For example, the mode can add
		-- a speciall button to the hud
		local
			pos_: Q_VECTOR_3D
		do
			ressources_.gl_manager.set_camera_behaviour( behaviour )
		end
		
	identifier : STRING is
		do
			result := "8ball bird"
		end
		
	default_next_state( ressources_: Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			--
		do
			result := ressources_.request_state( "8ball aim" )
			if result = void then
				result := create {Q_8BALL_AIM_STATE}.make_mode( mode )
				ressources_.put_state( result )
			end
		end
		
end -- class Q_8BALL_BIRD_STATE
