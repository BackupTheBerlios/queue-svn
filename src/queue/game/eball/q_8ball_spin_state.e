indexing
	description: "Allows to set, where the ball is hit"
	author: "Benjamin Sigg"

class
	Q_8BALL_SPIN_STATE

inherit
	Q_SPIN_STATE
	
creation
	make_mode
	
feature{NONE} -- creation
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
		end
	
feature -- interface
	prepare_next (hit_point_: Q_VECTOR_3D; ressources_: Q_GAME_RESSOURCES): Q_GAME_STATE is
		do
			
		end
		
	identifier : STRING is
		do
			result := "8ball spin"
		end
		

feature -- mode
	mode : Q_8BALL
	
	set_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
end -- class Q_8BALL_SPIN_STATE
