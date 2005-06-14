indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_ETH_HUMAN_PLAYER

inherit
	Q_ETH_PLAYER
	Q_HUMAN_PLAYER
feature -- state

	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		local
			reset_ : Q_ETH_RESET_STATE
			mode: Q_ETH
		do
			mode ?= ressources_.mode
--			result := ressources_.request_state( "8ball bird" )
--			if result = void then
--				result := create {Q_8BALL_BIRD_STATE}.make_mode( mode )
--				ressources_.put_state( result )
--			end

			reset_ ?= ressources_.request_state( "eth reset" )
			if result = void then
				create reset_.make_mode( mode )
				ressources_.put_state( reset_ )
			end
			result := reset_
			reset_.set_ball( mode.table.balls.item( mode.white_number ) )
		end

end -- class Q_ETH_HUMAN_PLAYER
