indexing
	description: "an 8ball human player, makes the first_state"
	author: "Severin Hacker"

class
	Q_8BALL_HUMAN_PLAYER

inherit
	Q_HUMAN_PLAYER
	Q_8BALL_PLAYER
	
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
		local
			reset_ : Q_8BALL_RESET_STATE
		do
--			result := ressources_.request_state( "8ball bird" )
--			if result = void then
--				result := create {Q_8BALL_BIRD_STATE}.make_mode( mode )
--				ressources_.put_state( result )
--			end

			reset_ ?= ressources_.request_state( "8ball reset" )
			if result = void then
				create reset_.make_mode( mode )
				ressources_.put_state( reset_ )
			end
			result := reset_
			reset_.set_ball( mode.table.balls.item( mode.white_number ) )
			reset_.set_headfield ( true )
		end
		

end -- class Q_8BALL_HUMAN_PLAYER
