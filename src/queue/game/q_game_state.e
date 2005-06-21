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
	description: "Controls the game until it finds out, witch state should follow"
	author: "Severin Hacker, Basil Fierz, Benjamin Sigg"

deferred class
	Q_GAME_STATE
	
feature
	install( ressources_ : Q_GAME_RESSOURCES ) is
		-- Installs this state. For example, the state can add
		-- a speciall button to the hud
		require
			ressources_ /= void
		deferred
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		-- Uninstalls this state. For example, if the state
		-- did add a button to the hud, it must now 
		-- remove this button.
		require
			ressources_ /= void
		deferred
		end
	
	step( ressources_ : Q_GAME_RESSOURCES ) is
		-- Is called from the game-loop. The State should here
		-- calculate witch changes are made (for example, add a 
		-- ball to the animation)
		require
			ressources_ /= void
		deferred
		end
		
	next( ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
		-- Is called from the game-loop. The state should 
		-- determin, if the current state is over, and a next
		-- game-state should be installed.
		-- If this state should stay, this method should return void
		-- If a next state is choosen (result /= void), this 
		-- state's uninstall-feature and the install-feature of the
		-- next node is invoked.
		require
			ressources_ /= void
		deferred
		end
	
	identifier : STRING is
		-- A String witch is used as unique identifier for this state
		-- The string should contain the name of the class, withoud the "q_"
		-- and without a "state", and only lower-case characters
		-- Example: Q_VIEW_STATE will return "view"
		deferred
		ensure
			result_exists : result /= void
		end
		

end -- class Q_GAME_STATE
