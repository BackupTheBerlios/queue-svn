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
	description: "Collision response handler, centralized design"
	author: "Andreas Kaegi"

class
	Q_PHYS_COLLISION_RESPONSE_HANDLER

create
	make
	
feature {NONE} -- create

	make (detector: Q_PHYS_COLLISION_DETECTOR) is
			-- Create response handler. 
			-- Initialize function list for the various object types.
		do
			create collision_list.make
			
			create fun_list.make(3, 3)
			
			fun_list.put (agent on_collide_ball_ball, 1, 1)

			fun_list.put (agent on_collide_ball_bank, 1, 2)
			fun_list.put (agent on_collide_ball_bank, 2, 1)
			
			fun_list.put (agent on_collide_ball_hole, 1, 3)
			fun_list.put (agent on_collide_ball_hole, 3, 1)
			
			fun_list.put (agent on_collide_dummy, 2, 3)
			fun_list.put (agent on_collide_dummy, 3, 2)
			
			fun_list.put (agent on_collide_dummy, 2, 2)
			fun_list.put (agent on_collide_dummy, 3, 3)
			
			collision_detector := detector

		end
		
feature -- interface

	on_collide (o1, o2: Q_OBJECT) is
			-- Handle collision between two objects.
		require
			o1 /= void
			o2 /= void
		local
			f: PROCEDURE[ANY, TUPLE[Q_OBJECT, Q_OBJECT]]
			args: TUPLE[Q_OBJECT, Q_OBJECT]
		do
			f := fun_list.item (o1.typeid, o2.typeid)
			
			if o1.typeid <= o2.typeid then
				args := [o1, o2]
			else
				args := [o2, o1]
			end
			
			f.call (args)
		end
	
	on_collide_ball_ball (o1, o2: Q_OBJECT) is
			-- Handle collision of two balls.
		require
			o1 /= void
			o2 /= void
		local
			ball1, ball2: Q_BALL
			t, n: Q_VECTOR_2D
			v1_minus_v2, v1_new, v2_new: Q_VECTOR_2D
		do
			ball1 ?= o1
			ball2 ?= o2
			
			o1.revert_update_position
			o2.revert_update_position
			
--			io.putstring ("bb: ")
--			io.putint (ball1.number)
--			io.putstring (" ")
--			io.putint (ball2.number)
--			io.put_new_line
			
			-- First of all add event to collision list
			if ball1.velocity.is_null then
				add_collision (ball2, ball1)
			else
				add_collision (ball1, ball2)
			end
			
			--  Idea: The collision of two balls is easy if one of them is standing still.
			--> Reduce the more complex problem to the above one by substracting v2 from
			--  both vectors v1 and v2.
			
			-- So let's first calculate the normal and the tangent vectors
			n := ball2.center - ball1.center
			n.normalize
			
			t := n.twin
			t.rotate_rectangularly
			
			v1_minus_v2 := ball1.velocity - ball2.velocity
			
			-- v1* = (v1*t) * t
			-- v1* = length * direction
			v1_new := t * v1_minus_v2.scalar_product (t)
			v2_new := n * v1_minus_v2.scalar_product (n)
			
			ball1.set_velocity (v1_new + ball2.velocity)
			ball2.set_velocity (v2_new + ball2.velocity)

		end
		
	on_collide_ball_bank (o1, o2: Q_OBJECT) is
			-- Handle bounce of ball at bank.
		require
			o1 /= void
			o2 /= void
		local
			ball: Q_BALL
			bank: Q_BANK
			line: Q_LINE_2D
			a, p, pr, distv: Q_VECTOR_2D
		do
			ball ?= o1
			bank ?= o2
			line := bank.bounding_object
			
			o1.revert_update_position
			o2.revert_update_position
			
			-- First of all add event to collision list
			add_collision (ball, bank)
			
			-- calc bounce point on bank
			distv := line.distance_vector (ball.center)
			a := ball.center - distv		-- bounce point on bank

			p := a - ball.velocity			-- point to reflect
			distv := line.distance_vector (p)
			pr := p - (distv * 2)			-- point "gespiegelt" at bank
			
			ball.set_velocity (a - pr)		-- bounced velocity			
			
		end
	
	on_collide_ball_hole (o1, o2: Q_OBJECT) is
			-- Handle ball-hole "collision"
			-- The ball only falls if its center is inside the hole
		require
			o1 /= void
			o2 /= void
		local
			ball: Q_BALL
			hole: Q_HOLE
		do
			ball ?= o1
			hole ?= o2
			
--			io.putstring ("hole")
--			io.put_new_line
			
			if ball.center.distance (hole.position) < hole.radius then
				-- Ball "inside" hole
				add_collision (ball, hole)
				collision_detector.remove_object (ball)
				
				ball.velocity.scale (0)
				ball.angular_velocity.scaled (0)
			end
			
		end
		
	on_collide_dummy (o1, o2: Q_OBJECT) is
			-- Do nothing on collision of these two types.
		once
		end
		
	collision_list: LINKED_LIST[Q_COLLISION_EVENT]
			-- List of all collisions since last start of the simulation, called by Q_SHOT_STATE

feature {NONE} -- implementation

	add_collision (agr: Q_BALL; def: Q_OBJECT) is
			-- Add collision event to collision_list
		local
			event: Q_COLLISION_EVENT
		do
			create event.make (agr, def)
			collision_list.force (event)
			
		end
		
	fun_list: ARRAY2[PROCEDURE[ANY, TUPLE[Q_OBJECT, Q_OBJECT]]]
	
	collision_detector: Q_PHYS_COLLISION_DETECTOR
	
end -- class Q_PHYS_COLLISION_RESPONE_HANDLER
