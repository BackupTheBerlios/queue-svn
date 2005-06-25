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
	description: "Allows to set, in witch direction the ball is shot"
	author: "Benjamin Sigg"

class
	Q_8BALL_AIM_STATE

inherit
	Q_AIM_STATE
	redefine
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
	
	out_of_headfield : BOOLEAN -- if the player must play out of the headfield
	
feature
	identifier : STRING is
		do
			result := "8ball aim"
		end
		
	install( ressources_ : Q_GAME_RESSOURCES ) is
		do
			set_ball( mode.table.balls.item( mode.white_number ))
			
			precursor( ressources_ )			
			ressources_.gl_manager.add_hud( mode.info_hud )
		end
		
	uninstall( ressources_ : Q_GAME_RESSOURCES ) is
		do
			precursor( ressources_ )
			ressources_.gl_manager.remove_hud( mode.info_hud )
			out_of_headfield := false
		end
		
	set_out_of_headfield(o_ : BOOLEAN) is
		do
			out_of_headfield := o_
		end
		
		
	prepare_next_state( direction_ : Q_VECTOR_2D; ressources_ : Q_GAME_RESSOURCES ): Q_GAME_STATE is
		local
			spin_ : Q_8BALL_SPIN_STATE
			info_ : Q_8BALL_INFO_STATE
		do
			if not is_valid_direction( direction_ ) then
				info_ ?= ressources_.request_state( "8ball wrong aim" )
				if info_ = void then
					create info_.make_mode( mode, false, "8ball wrong aim" )
					ressources_.put_state( info_ )
					
					info_.set_text( "Invalid direction for a shot.", 1 )
					info_.set_text( "Try again.", 2 )
				end
				info_.set_waiting_next_state( current )
				result := info_
			else
				spin_ ?= ressources_.request_state( "8ball spin" )
				if spin_ = void then
					create spin_.make_mode( mode )
					ressources_.put_state( spin_ )
				end
				spin_.set_ball( ball )
				spin_.set_shot( create {Q_SHOT}.make (ball, direction_) )
				spin_.set_shot_direction( direction_ )
				result := spin_
			end
		end
		
	is_valid_direction(direction_ : Q_VECTOR_2D) : BOOLEAN is
			-- is this a valid direction to shoot in the current state of the game
		do
			Result := out_of_headfield implies direction_.x>0
		end
		
		

end -- class Q_8BALL_AIM_STATE
