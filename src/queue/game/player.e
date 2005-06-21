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
	description: "Objects that represent a billard player"
	author: "Severin Hacker"
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
