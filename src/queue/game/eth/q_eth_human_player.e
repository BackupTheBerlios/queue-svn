--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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

creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_ETH ) is
		do
			mode := mode_
			create fallen_balls.make
		end
		
	mode : Q_ETH

	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		local
			reset_ : Q_ETH_RESET_STATE
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
			mode.table.balls.item(mode.white_number).set_center (mode.head_point)
			reset_.set_ball( mode.table.balls.item( mode.white_number ) )
			result := reset_
		end

end -- class Q_ETH_HUMAN_PLAYER
