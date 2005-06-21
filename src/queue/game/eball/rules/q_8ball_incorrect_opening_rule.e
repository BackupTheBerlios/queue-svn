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
	description: "Player made an incorrect opening shot, let user(s) decide"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_INCORRECT_OPENING_RULE

inherit
	Q_8BALL_RULE

create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
	
	identifier : STRING is "8ball incorrect opening rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		do
			Result := mode.first_shot and not is_correct_opening(colls_)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
		--Gelingt ihm das nicht, so begeht er ein Foul und der dann aufnahmeberechtigte Spieler kann
		--a) die Position so übernehmen und weiterspielen oder
		--b) die Kugeln neu aufbauen lassen und selbst einen neuen Eröffnungsstoß durchführen oder den Gegner neu anstoßen lassen.
	local
			choice_state_ : Q_8BALL_CHOICE_STATE
		do
			choice_state_ ?= ressources_.request_state ("8ball incorrect opening")
			if choice_state_ = void then
				create choice_state_.make_mode_titled (mode,mode.active_player.name+" made an incorrect opening", "8ball incorrect opening",3)
				choice_state_.button (1).set_text ("Continue with this table")
				choice_state_.button (1).actions.force (agent handle_continue(ressources_,?,?,choice_state_))
				choice_state_.button (2).set_text ("Reset balls and restart yourself")
				choice_state_.button (2).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
				choice_state_.button (3).set_text ("Reset balls and let opponent restart")
				choice_state_.button (3).actions.force (agent handle_restart_other(ressources_,?,?,choice_state_))
			end
			Result := choice_state_
		end
		
		
end -- class Q_8BALL_INCORRECT_OPENING_RULE
