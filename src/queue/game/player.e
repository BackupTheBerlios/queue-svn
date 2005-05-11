indexing
	description: "Objects that represent a billard player"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_PLAYER

feature -- Interface

	next_shot(situation_ : Q_TABLE): SHOT is
			-- returns the shot the player wants to play next
		require
			situation_exists : situation_ /= Void
		deferred
		ensure
			result_exists : Result /=Void
		end
		

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class PLAYER
