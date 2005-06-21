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
	description: "Allows to set, where the ball is hit"
	author: "Benjamin Sigg"

class
	Q_ETH_SPIN_STATE

inherit
	Q_SPIN_STATE
	redefine
		install, uninstall
	end
	
creation
	make_mode
	
feature{NONE} -- creation
	make_mode( mode_ : Q_ETH ) is
		do
			make
			mode := mode_
		end
	
feature -- interface
	prepare_next (hit_point_: Q_VECTOR_3D; ressources_: Q_GAME_RESSOURCES): Q_GAME_STATE is
		local
			shot_state_ :Q_ETH_SHOT_STATE
		do
			-- set hit_point
			shot_state_ ?= ressources_.request_state( "eth shot" )
			if shot_state_ = void then
				create shot_state_.make_mode( mode )
				ressources_.put_state( shot_state_ )
			end
			shot.set_hitpoint (hit_point_)
			shot_state_.set_shot (shot)
			result := shot_state_
		end
		
	identifier : STRING is
		do
			result := "eth spin"
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

feature -- mode
	mode : Q_ETH
	
	set_mode( mode_ : Q_ETH ) is
		do
			mode := mode_
		end
	
	shot: Q_SHOT
		
	set_shot(shot_: Q_SHOT) is
		require
			shot_ /= Void
		do
			shot := shot_
		end
		
		
end -- class Q_8BALL_SPIN_STATE
