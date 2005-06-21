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
	description: "This state allows to look around and do nothing."
	author: "Benjamin Sigg"

class
	Q_8BALL_BIRD_STATE

inherit
	Q_BIRD_STATE
	redefine
		identifier,
		default_next_state,
		install, uninstall
	end

creation
	make_mode
	
feature{NONE} -- creation
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
		end
	
	mode : Q_8BALL
	
feature
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.add_hud( mode.info_hud )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.info_hud )
		end		
		
	identifier : STRING is
		do
			result := "8ball bird"
		end
		
	default_next_state( ressources_: Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			--
		do
			result := ressources_.request_state( "8ball aim" )
			if result = void then
				result := create {Q_8BALL_AIM_STATE}.make_mode( mode )
				ressources_.put_state( result )
			end
		end
		
end -- class Q_8BALL_BIRD_STATE
