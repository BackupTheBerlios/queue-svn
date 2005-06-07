indexing
	description: "Objects that call the physics engine and deal with the rules"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_SIMULATION_STATE

inherit
	Q_SIMULATION_STATE
	
feature
	
	identifier : STRING is
		do
			Result := "8ball simulation"
		end
		
		
	set_shot(shot_ : Q_SHOT) is
		require
			shot_ /= Void
		do
			shot := shot_
		end
		
feature{NONE}
	shot : Q_SHOT
	
end -- class Q_8BALL_SIMULATION
