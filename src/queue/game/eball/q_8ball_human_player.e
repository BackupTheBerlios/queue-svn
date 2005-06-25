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
	description: "an 8ball human player, makes the first_state"
	author: "Severin Hacker"

class
	Q_8BALL_HUMAN_PLAYER

inherit
	Q_HUMAN_PLAYER
	Q_8BALL_PLAYER
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
			create fallen_balls.make
			create color.make_empty
		end
		
	mode : Q_8BALL
	
feature
	first_state( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		local
			reset_ : Q_8BALL_RESET_STATE
		do

			reset_ ?= ressources_.request_state( "8ball reset" )
			if result = void then
				create reset_.make_mode( mode )
				ressources_.put_state( reset_ )
			end
			result := reset_
			reset_.set_ball( mode.table.balls.item( mode.white_number ) )
			reset_.set_headfield ( true )
		end
		

end -- class Q_8BALL_HUMAN_PLAYER
