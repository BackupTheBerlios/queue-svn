indexing
	description: "Set the white ball on the table"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_RESET_STATE

inherit
	Q_RESET_STATE	redefine
		identifier
	end
	
	Q_CONSTANTS
	
creation
	make
	
feature

	identifier : STRING is
		do
			result := "8ball reset"
		end
		
		
	prepare_next_state( ball_position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Calculates the next state. This means, saving the position of the ball, and
			-- searching/creating a new state.
			-- If no next state is available, return void
			-- ball_position_ : Where the user wants to put the ball
			-- ressources_ : Additional informations
		do
			-- set the position of the ball
			ressources_.mode.table.balls.item (white_number).set_center (ball_position)
			
			-- set next state as bird state
			result := ressources_.request_state( "8ball bird" )
			if result = void then
				result := create {Q_8BALL_BIRD_STATE}.make_mode(ressources_.mode)
				ressources_.put_state( result )
			end
		end

end -- class Q_8BALL_RESET_STATE
