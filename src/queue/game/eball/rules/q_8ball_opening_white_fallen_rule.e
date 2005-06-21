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
	description: "The white ball has fallen in the opening shot"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_8BALL_OPENING_WHITE_FALLEN_RULE

inherit
	Q_8BALL_RULE

create
	make_mode
	
feature -- rule

	make_mode( mode_ : Q_8BALL ) is
		do
			mode := mode_
		end
		
	identifier :STRING is "8ball opening white has fallen rule"
	
	is_guard_satisfied(colls_: LIST[Q_COLLISION_EVENT]): BOOLEAN is
		local
			fb_: LINKED_LIST[INTEGER]
		do
			fb_ := mode.fallen_balls (colls_)
			Result := mode.first_shot and then is_correct_opening (colls_) and then fb_.has(white_number) and not fb_.has(8)
		end
		
	next_state(ressources_: Q_GAME_RESSOURCES) : Q_GAME_STATE is
			-- rule 4.7
			-- white has fallen in a correct opening shot
			-- Der dann aufnahmeberechtigte Spieler hat Lageverbesserung im Kopffeld und darf keine Kugel direkt anspielen, 
		local
			reset_state_ : Q_8BALL_RESET_STATE
			aim_state_: Q_8BALL_AIM_STATE
		do
			reset_state_ ?= ressources_.request_state( "8ball reset" )
			if reset_state_ = void then
				reset_state_ := create {Q_8BALL_RESET_STATE}.make_mode( mode )
				ressources_.put_state( reset_state_ )
			end
			reset_state_.set_ball (ressources_.mode.table.balls.item(white_number))
			reset_state_.set_headfield (true)
			-- player can shot only out of headfield in next turn
			aim_state_ ?= ressources_.request_state ("8ball aim")
			aim_state_.set_out_of_headfield (true)
			mode.switch_players
			Result := reset_state_
		end
		
end -- class Q_8BALL_OPENING_WHITE_FALLEN_RULE
