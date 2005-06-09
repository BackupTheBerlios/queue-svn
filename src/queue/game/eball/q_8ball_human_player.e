indexing
	description: "an 8ball human player, makes the first_state"
	author: "Severin Hacker"

class
	Q_8BALL_HUMAN_PLAYER

inherit
	Q_HUMAN_PLAYER

creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	mode : Q_8BALL
	
feature
	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		do
			result := ressources_.request_state( "8ball bird" )
			if result = void then
				result := create {Q_8BALL_BIRD_STATE}.make_mode( mode )
				ressources_.put_state( result )
			end
		end
		

end -- class Q_8BALL_HUMAN_PLAYER
