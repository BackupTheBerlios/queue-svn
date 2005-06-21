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
	description: "The active player has won the game, all balls of his color have fallen and the black ball has fallen"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_WON_RULE

inherit
	Q_8BALL_RULE
create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier:STRING is "8ball won rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := is_game_won (colls_)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		local
			choice_state_ : Q_8BALL_CHOICE_STATE
		do
			choice_state_ ?= ressources_.request_state("8ball won")
			if choice_state_ = void then
				create choice_state_.make_mode_titled (mode, mode.active_player.name+" wins", "8ball won", 2)
				choice_state_.button (1).set_text ("Play again")
				choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
				choice_state_.button (2).set_text ("Main menu")
				choice_state_.button (2).actions.force (agent handle_main_menu(ressources_,?,?,choice_state_))
			end
			choice_state_.set_title (mode.active_player.name+" wins")
			Result := choice_state_
		end
		
end -- class Q_8BALL_WON_RULE
