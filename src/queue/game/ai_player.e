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
		

	next_shot(gr_ : Q_GAME_RESSOURCES): Q_SHOT is
			-- returns the shot the player wants to play next
		require
			gr_ /= Void
		deferred
		ensure
			result_exists : Result /=Void
		end

invariant
	invariant_clause: True -- Your invariant here

end -- class AI_PLAYER
