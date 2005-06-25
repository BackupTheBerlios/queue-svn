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
	description: "Objects that test if the rules work correctly"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	HAC_8BALL_TEST

inherit
	Q_TEST_CASE
	
feature
	
	name : STRING is "8Ball rules test"
		
	init is
			-- Invoked when this test ist choosen.
		do
			create tests.make
			tests.force(["test_incorrect_shot_rule", agent test_incorrect_shot_rule])
			set_up_mode
			run_tests
		end

		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		local
			cam: Q_GL_CAMERA
		do
			cam ?= root_.transform
			cam.set_position (200, 0, 400)
			cam.set_alpha (0)
			cam.set_beta (0)
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := void
		end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		do
			result := void
		end
		
	max_bound : Q_VECTOR_3D is
			-- A vector, the maximal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make(200, 200, 0)
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make(0, 0, 0)
		end
feature {NONE}
	tests : LINKED_LIST[TUPLE[STRING,FUNCTION [ANY, TUPLE, LIST[BOOLEAN]]]]
	eball : Q_8BALL
	logger: Q_LOGGER
	
	run_tests is
			-- check if test holds
		local
			test_ : FUNCTION[ANY,TUPLE,LINKED_LIST[BOOLEAN]]
			results_ : LINKED_LIST[BOOLEAN]
		do
			from
				tests.start
			until
				tests.after
			loop
				test_ ?= tests.item.item (2)
				test_.call ([])
				io.put_string (tests.item.item(1).out+": [")
				results_ ?= test_.last_result
				from
					results_.start
				until
					results_.after
				loop
					io.put_string(results_.item.out+" ")
					results_.forth
				end
				io.put_string ("]")
				tests.forth
			end
		end
		
	set_up_mode is
			-- sets common variables for testing
		do
			create eball.make
			eball.set_logger (create {Q_LOGGER}.make)
		end
		
	
	test_incorrect_shot_rule: LINKED_LIST[BOOLEAN] is
			-- test if the correct shot rule works as expected
		local
			c_ : LINKED_LIST[Q_COLLISION_EVENT]
			incorrect_shot_rule_ : Q_8BALL_INCORRECT_SHOT_RULE
		do	
			create result.make
			eball.set_player_a (eball.human_player)
			eball.player_a.set_name ("andy")
			eball.set_player_b (eball.human_player)
			eball.player_b.set_name("basil")
			
			-- andy is playing
			eball.set_active_player (eball.player_a)
			eball.set_first_shot (false)
			
			-- create an incorrect shot			
			-- it is andy's turn but he touches first a ball from basil
			eball.close_table(3)
			create incorrect_shot_rule_.make_mode (eball)
			create c_.make
			c_.force (create {Q_COLLISION_EVENT}.make (eball.table.balls.item(0),eball.table.balls.item(9)))
			result.force (incorrect_shot_rule_.is_guard_satisfied (c_) = true)
			
			-- create a correct shot, the guard of incorrect_shot_rule should be false
			create c_.make
			c_.force (create {Q_COLLISION_EVENT}.make (eball.table.balls.item(0),eball.table.balls.item(4)))
			c_.force (create {Q_COLLISION_EVENT}.make (eball.table.balls.item(4),eball.table.holes.item (1)))
			result.force (incorrect_shot_rule_.is_guard_satisfied (c_) = false)
			
		end

		
	
end -- class HAC_8BALL_TEST
