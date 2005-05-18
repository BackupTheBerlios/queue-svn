indexing
	description: "Objects that represent an artificial intelligence (AI) player"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_AI_PLAYER

inherit
	Q_PLAYER

feature {NONE} -- Implementation

	next_shot(situation_ : Q_TABLE): Q_SHOT is
			-- returns the shot the player wants to play next
		require
			situation_exists : situation_ /= Void
		deferred
		ensure
			result_exists : Result /=Void
		end

invariant
	invariant_clause: True -- Your invariant here

end -- class AI_PLAYER
