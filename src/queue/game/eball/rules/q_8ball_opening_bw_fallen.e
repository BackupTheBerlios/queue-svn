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
	description: "The black ball has fallen in the opening shot"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_OPENING_BLACK_FALLEN_RULE

inherit
	Q_8BALL_RULE

create
	make_mode
	
feature -- rule
	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball opening black has fallen rule"
	
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		local
			fb_: LINKED_LIST[INTEGER]
		do
			fb_ := mode.fallen_balls (colls_)
			Result := mode.first_shot and then is_correct_opening (colls_) and then fb_.has(8) and not fb_.has (white_number)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- rule 4.9 first part
			--(1) Wird die "8" mit dem Eröffnungsstoß versenkt, so kann der eröffnende Spieler verlangen, daß
			--a) neu aufgebaut wird oder
			--b) die "8" wieder eingesetzt wird und er selbst so weiterspielt.
		local
			choice_state_ : Q_8BALL_CHOICE_STATE
		do
			choice_state_ ?= ressources_.request_state ("8ball 8 fallen")
			if choice_state_ = void then
				create choice_state_.make_mode_titled (mode, "Correct opening but 8 has fallen", "8ball 8 fallen", 2)
				choice_state_.button (1).set_text ("Rebuild the table and start yourself")
				choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
				choice_state_.button (2).set_text ("Reset 8 and continue playing")
				choice_state_.button (2).actions.force (agent handle_set8_and_continue(ressources_,?,?,choice_state_))
			end
			result := choice_state_
		end

end -- class Q_8BALL_OPENING_BW_FALLEN
