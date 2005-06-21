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
	description: "Objects that call the physics engine and deal with the rules"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_ETH_SIMULATION_STATE

inherit
	Q_SIMULATION_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_ETH ) is
		do
			make
			mode := mode_
		end
		
feature
	
	identifier : STRING is
		do
			Result := "eth simulation"
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.time_info_hud )
			mode.time_info_hud.start
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.time_info_hud )
			mode.time_info_hud.stop
		end
		
	simulation_step (ressources_: Q_GAME_RESSOURCES): BOOLEAN is
			-- Makes one step of the physics. If the physics has done its job, false is
			-- returns. If the physics is still working, true is returned.
		do
			if not ressources_.simulation.has_finished and not mode.time_info_hud.over then
				ressources_.simulation.step (ressources_.mode.table, ressources_.time)
				mode.delete_fallen_balls(ressources_)
				Result := true
			else
				Result := false
			end
		end
		
	prepare_next_state (ressources_: Q_GAME_RESSOURCES): Q_GAME_STATE is
		-- what do to after physics has finished
		do
			-- ask the mode what to do according to result set
			Result := ressources_.mode.next_state (ressources_)
		end
		
feature{NONE}
	mode : Q_ETH
		
	
end -- class Q_8BALL_SIMULATION
