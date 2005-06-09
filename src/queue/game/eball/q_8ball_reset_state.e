indexing
	description: "Set the white ball on the table"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_RESET_STATE

inherit
	Q_RESET_STATE	redefine
		identifier, install, uninstall
	end
	
	Q_CONSTANTS
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
		end
		
	
feature
	mode : Q_8BALL
	
	set_headfield(headfield_ : BOOLEAN) is
			-- the user can reset the ball only in the headfield if headfield_ is true
		do
			headfield := headfield_
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
		local
			mode_: Q_8BALL
		do
			-- set the position of the ball
			ressources_.mode.table.balls.item (white_number).set_center (ball_position)
			
			-- set next state as bird state
			result := ressources_.request_state( "8ball bird" )
			if result = void then
				mode_ ?= ressources_.mode
				result := create {Q_8BALL_BIRD_STATE}.make_mode (mode_)
				ressources_.put_state( result )
			end
		end
		
	valid_position( ball_position_ : Q_VECTOR_2D; ressources_: Q_GAME_RESSOURCES ) : BOOLEAN is
			-- true if the given ball-position is valid, otherwise false
		local
			mode_ : Q_8BALL
		do
			if headfield then
				mode_ ?= ressources_.mode
				Result := mode_.is_in_headfield (ball_position_) and then mode_.valid_position (ball_position_)
			else
				Result := ressources_.mode.valid_position (ball_position_)
			end
		end
		
	headfield :BOOLEAN

end -- class Q_8BALL_RESET_STATE
