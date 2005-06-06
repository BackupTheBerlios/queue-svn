indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
		do
--				*****************
--				to be implemented
		end
		

end -- class Q_8BALL_AIM_STATE
