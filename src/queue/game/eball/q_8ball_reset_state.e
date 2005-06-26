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
	description: "Set the white ball on the table"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_RESET_STATE

inherit
	Q_RESET_STATE	redefine
		identifier, install, uninstall
	end
	
	Q_CONSTANTS
	
creation
	make_mode
	
feature{NONE}
	make_mode( mode_ : Q_8BALL ) is
		do
			make
			mode := mode_
		end
		
	
feature
	mode : Q_8BALL
	
	set_headfield(headfield_ : BOOLEAN) is
			-- the user can reset the ball only in the headfield if headfield_ is true
		do
			headfield := headfield_
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			-- set camera
			mode.reset_camera (ressources_)
			ressources_.gl_manager.add_hud( mode.info_hud )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.info_hud )
			headfield := false
		end

	identifier : STRING is
		do
			result := "8ball reset"
		end
		
		
	prepare_next_state( ball_position_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ) : Q_GAME_STATE is
			-- Calculates the next state. This means, saving the position of the ball, and
			-- searching/creating a new state.
			-- If no next state is available, return void
			-- ball_position_ : Where the user wants to put the ball
			-- ressources_ : Additional informations
		local
			mode_: Q_8BALL
		do
			-- set the position of the ball
			ressources_.mode.table.balls.item (white_number).set_center (ball_position)
			
			-- set next state as aim state
			result := ressources_.request_state( "8ball aim" )
			if result = void then
				mode_ ?= ressources_.mode
				result := create {Q_8BALL_AIM_STATE}.make_mode (mode_)
				ressources_.put_state( result )
			end
		end
		
	valid_position( ball_position_ : Q_VECTOR_2D; ressources_: Q_GAME_RESSOURCES ) : BOOLEAN is
			-- true if the given ball-position is valid, otherwise false
		local
			mode_ : Q_8BALL
		do			
			if headfield then
				mode_ ?= ressources_.mode
				Result := mode_.is_in_headfield (ball_position_) 
					and then mode_.valid_position (ball_position_, ball,ressources_.simulation)
			else
				Result := ressources_.mode.valid_position (ball_position_, ball,ressources_.simulation)
			end
		end
		
	headfield :BOOLEAN

end -- class Q_8BALL_RESET_STATE
