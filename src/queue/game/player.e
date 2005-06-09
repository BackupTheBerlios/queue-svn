indexing
	description: "Objects that represent a billard player"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_PLAYER

	
feature -- Interface
	name : STRING -- the name of the player
	
	set_name(name_: STRING) is
			-- sets the name of the player
		do
			name := name_
		ensure
			name = name_
		end

	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- returns the first state, when this player wants to play
		deferred
		ensure
			result /= void
		end
		

feature {NONE} -- Implementation

invariant
	name_set : name /= Void

end -- class PLAYER
