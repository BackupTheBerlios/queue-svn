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

	set_ability(ability_ : INTEGER) is
			-- set the ability of the AI player 10 is best, 1 is worst
		require
			ability_ >= 1 and then ability_ <=10
		deferred
		end
		

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
