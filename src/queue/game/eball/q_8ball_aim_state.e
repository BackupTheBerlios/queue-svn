indexing
	description: "Allows to set, in witch direction the ball is shot"
	author: "Benjamin Sigg"

class
	Q_8BALL_AIM_STATE

inherit
	Q_AIM_STATE

creation
	make_mode
	
feature{NONE} -- creation
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
			set_ball( mode.table.balls.item( mode.white_number ))
		end
	
	mode : Q_8BALL
	
feature
	identifier : STRING is
		do
			result := "8ball aim"
		end
		
	prepare_next_state( direction_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ): Q_GAME_STATE is
		local
			spin_ : Q_8BALL_SPIN_STATE
		do
			spin_ ?= ressources_.request_state( "8ball spin" )
			if spin_ = void then
				create spin_.make_mode( mode )
				ressources_.put_state( spin_ )
			end
			spin_.set_ball( ball )
			spin_.set_shot( create {Q_SHOT}.make (direction_) )
			result := spin_
		end
		

end -- class Q_8BALL_AIM_STATE
