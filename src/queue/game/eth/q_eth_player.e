indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_ETH_PLAYER

inherit
	Q_PLAYER
	
feature	
	fallen_balls : LINKED_LIST[Q_BALL] -- the balls that this player has correctly shot

end -- class Q_ETH_PLAYER
