indexing
	description: "Collision response handler, centralized design"
	author: "Andreas Kaegi"

class
	Q_PHYS_COLLISION_RESPONSE_HANDLER

create
	make
	
feature {NONE} -- create

	make is
			-- Create repsonse handler. 
			-- Initialize function list for the various object types.
		do
			create fun_list.make(2, 2)
			
			fun_list.put(agent on_collide_dummy, 1, 1)
			fun_list.put(agent on_collide_ball_bank, 1, 2)
			fun_list.put(agent on_collide_ball_bank, 2, 1)
			fun_list.put(agent on_collide_dummy, 2, 2)
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
			line := bank.bounding_line
			
			-- calc bounce point on bank
			distv := line.distance_vector (ball.center)
			a := ball.center - distv		-- bounce point on bank
			p := a - ball.velocity			-- point to reflect
			distv := line.distance_vector (p)
			pr := p - (distv * 2)			-- point "gespiegelt" at bank
			
			ball.set_velocity (a - pr)		-- bounced velocity

		end
		
	on_collide_dummy (o1, o2: Q_OBJECT) is
			-- Do nothing on collision of these two types.
		once
		end


feature {NONE} -- implementation

	fun_list: ARRAY2[PROCEDURE[ANY, TUPLE[Q_OBJECT, Q_OBJECT]]]
	
end -- class Q_PHYS_COLLISION_RESPONE_HANDLER
