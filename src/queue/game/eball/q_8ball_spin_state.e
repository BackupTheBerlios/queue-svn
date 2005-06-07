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
			--make
			mode := mode_
		end
	
feature -- interface
	prepare_next (hit_point_: Q_VECTOR_3D; ressources_: Q_GAME_RESSOURCES): Q_GAME_STATE is
		local
			shot_state_ :Q_8BALL_SHOT_STATE
		do
			-- set hit_point
			shot_state_ ?= ressources_.request_state( "8ball shot" )
			if shot_state_ = void then
				create shot_state_
				ressources_.put_state( shot_state_ )
			end
			shot.set_hitpoint (hit_point_)
			shot_state_.set_shot (shot)
			result := shot_state_
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
	
	shot: Q_SHOT
		
	set_shot(shot_: Q_SHOT) is
		require
			shot_ /= Void
		do
			shot := shot_
		end
		
		
end -- class Q_8BALL_SPIN_STATE
