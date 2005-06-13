indexing
	description: "An 8ball player. Stores scoring information"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_8BALL_PLAYER

inherit
	Q_PLAYER
	
feature	
	fallen_balls : LINKED_LIST[Q_BALL] -- the balls that this player has correctly shot

end -- class Q_8BALL_PLAYER
