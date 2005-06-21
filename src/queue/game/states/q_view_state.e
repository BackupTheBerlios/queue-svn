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
	-- Objects that represent the View Mode for human-user-interaction.
	-- User can fly over the table and look at the situation
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_BIRD_STATE

inherit
	Q_ESCAPABLE_STATE
	
creation
	make
	
feature{NONE}
	make is
		do
			create behaviour.make
			
			behaviour.set_rotate_vertical_min( -80 )
			behaviour.set_rotate_vertical_max( 30 )
		end
		
feature{NONE} -- values
	behaviour : Q_FREE_CAMERA_BEHAVIOUR
	
feature -- from Q_GAME_STATE
	install( ressources_ : Q_GAME_RESSOURCES ) is
		-- Installs this mode. For example, the mode can add
		-- a speciall button to the hud
		do
			ressources_.gl_manager.set_camera_behaviour( behaviour )
		end
	
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		-- Uninstalls this mode. For example, if the mode
		-- did add a button to the hud, it must now 
		-- remove this button.
		do
			ressources_.gl_manager.set_camera_behaviour( void )
		end
	
	step( ressources_: Q_GAME_RESSOURCES ) is
		do
			-- do nothing
		end
		
	
	identifier : STRING is
		-- A String witch is used as unique identifier for this state
		-- The string should contain the name of the class, without the "q_"
		-- and withoud a "state", and only lower-case characters
		-- Example: Q_VIEW_STATE will return "view"
		do
			result := "bird state"
		end

end -- class Q_VIEW_STATE
