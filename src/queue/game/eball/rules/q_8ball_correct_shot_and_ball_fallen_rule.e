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
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_CORRECT_SHOT_AND_BALL_FALLEN_RULE

inherit
	Q_8BALL_RULE
	
create
	make_mode
	
feature -- rule
	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball correct shot and ball fallen rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := (not mode.fallen_balls(colls_).is_empty) and then ((mode.first_shot and is_correct_opening(colls_)) or else (not mode.first_shot and then is_correct_shot(colls_, mode.active_player)))
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		do
				mode.set_first_shot (false)
				-- set next state as bird state
				result := ressources_.request_state( "8ball bird" )
				if result = void then
					result := create {Q_8BALL_BIRD_STATE}.make_mode (mode)
					ressources_.put_state( result )
				end
		end


end -- class Q_8BALL_CORRECT_SHOT_AND_BALL_FALLEN_RULE
