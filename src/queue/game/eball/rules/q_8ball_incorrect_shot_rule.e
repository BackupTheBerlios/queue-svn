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
	description: "Player made an incorrect shot, other player can set the white ball"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_INCORRECT_SHOT_RULE

inherit
	Q_8BALL_RULE
	Q_CONSTANTS

create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball incorrect shot rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := (not mode.first_shot and then (not is_correct_shot (colls_, mode.active_player))) or else mode.fallen_balls(colls_).has(white_number)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- rule 4.15
			-- the player made an incorrect shot during the game
			--(1) Der Gegner hat freie Lageverbesserung auf dem ganzen Tisch. 
		local
			reset_state_ : Q_8BALL_RESET_STATE
		do
				reset_state_ ?= ressources_.request_state( "8ball reset" )
				if reset_state_ = void then
					reset_state_ := create {Q_8BALL_RESET_STATE}.make_mode( mode )
					ressources_.put_state( reset_state_ )
				end
				reset_state_.set_ball (ressources_.mode.table.balls.item(white_number))
				reset_state_.set_headfield (false)
				mode.switch_players
				Result := reset_state_
		end
		
		
end -- class Q_8BALL_INCORRECT_SHOT_RULE
