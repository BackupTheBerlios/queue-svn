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
	description: "The active player has lost the game"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_LOST_RULE

inherit
	Q_8BALL_RULE

create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball lost rule"
		
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
			-- is the game lost
			-- 4.20 Verlust des Spiels
--				(1) Ein Spieler verliert das Spiel, wenn er
--				a) ein Foul spielt, während er die "8" versenkt (Ausnahme: siehe "8" fällt beim Eröffnungsstoß)
--				b) die "8" mit demselben Stoß versenkt, mit dem er die letzte Farbige versenkt
--				c) die "8" vom Tisch springen läßt
--				d) die "8" in eine andere als die angesagte Tasche versenkt
--				e) die "8" versenkt, bevor er berechtigt ist, darauf zu spielen.
		local
			foul_8, last_8, too_early_8: BOOLEAN
			i : INTEGER
		do
			foul_8 := mode.fallen_balls (colls_).has (8) and not is_correct_shot (colls_,mode.active_player)
			from
				i := 1
			until
				i > 15
			loop
				last_8 := last_8 or (mode.fallen_balls (colls_).has (i) and mode.table.balls.item (i).owner.has (mode.active_player))
				i := i+1
			end
			last_8 := last_8 and mode.fallen_balls (colls_).has (8)
			too_early_8 := not all_balls_fallen and mode.fallen_balls (colls_).has (8)
			Result := foul_8 or last_8 or too_early_8
		end

	action is
			-- change position of balls switch players, etc.
		do
		end
		
	next_state(ressources_:Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- what to do next?
		local
			choice_state_ : Q_8BALL_CHOICE_STATE
		do
			choice_state_ ?= ressources_.request_state ("8ball lost")
				if choice_state_ = void then
					create choice_state_.make_mode_titled( mode, mode.active_player.name+" loses", "8ball lost", 2)
					choice_state_.button (1).set_text ("Play again")
					choice_state_.button (1).actions.force (agent handle_restart(ressources_,?,?,choice_state_))
					choice_state_.button (2).set_text ("Main menu")
					choice_state_.button (2).actions.force (agent handle_main_menu(ressources_,?,?,choice_state_))
				end
				choice_state_.set_title(mode.active_player.name+" loses")
				Result := choice_state_
		end

end -- class Q_8BALL_LOST_RULE
