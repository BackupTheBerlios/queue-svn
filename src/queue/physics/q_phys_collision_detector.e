indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_PHYS_COLLISION_DETECTOR

create
	make
	
feature -- interface

	make is
			-- Creation proc
		do
			create obj_list.make
			create fun_list.make(2, 2)
			
			fun_list.put(agent does_collide_ball_ball, 1, 1)
			fun_list.put(agent does_collide_ball_bank, 1, 2)
			fun_list.put(agent does_collide_ball_bank, 2, 1)
			fun_list.put(agent does_collide_bank_bank, 2, 2)
			
		end
		
	add_object(o: Q_OBJECT) is
			-- Add collision detection support for object o
		do
			obj_list.put_first (o)
		end
		
	remove_object(o: Q_OBJECT) is
			-- Remove collision detection support for object o
		do
			obj_list.delete (o)
		end
		
	collision_test is
			-- Checks if any element collides with any other element O(n*(n-1)*(n-2)*...*1)
		local
			cursor1, cursor2: DS_LINKED_LIST_CURSOR [Q_OBJECT]
		do
			create cursor1.make (obj_list)
			create cursor2.make (obj_list)
			from 
				cursor1.start
			until
				cursor1.off
			loop
				from
					cursor2.go_to (cursor1)
					cursor2.forth
				until
					cursor2.off
				loop
					if does_collide(cursor1.item, cursor2.item) then
						cursor1.item.on_collide(cursor2.item)
						cursor2.item.on_collide(cursor1.item)
					end
					cursor2.forth
				end
				cursor1.forth
			end
		end
		
feature -- implementation

	does_collide(o1, o2: Q_OBJECT): BOOLEAN is
			-- Collision detection between o1 and o2
		local
			f: FUNCTION[ANY, TUPLE[Q_OBJECT, Q_OBJECT], BOOLEAN]
			args: TUPLE[Q_OBJECT, Q_OBJECT]
		do
			f := fun_list.item (o1.typeid, o2.typeid)
			
			if o1.typeid <= o2.typeid then
				args := [o1, o2]
			else
				args := [o2, o1]
			end
			
			Result := f.item (args)
		end
		
	does_collide_ball_ball(o1, o2: Q_OBJECT): BOOLEAN is
			-- Collision detection between two balls
		local
			b1, b2: Q_BALL
			dist: DOUBLE
		do
			b1 ?= o1
			b2 ?= o2
			
			dist := b1.center.distance (b2.center)
			
			Result := dist <= (b1.radius + b2.radius)
		end
		
	does_collide_ball_bank(o1, o2: Q_OBJECT): BOOLEAN is
			-- Collision detection between ball o1 and bank o2
		local
			ball: Q_BALL; bank: Q_BANK
			dist: DOUBLE
		do
			ball ?= o1
			bank ?= o2
			
			dist := bank.distance_vector (ball.center)
			
			Result := dist <= ball.radius
		end
		
	does_collide_bank_bank(o1, o2: Q_OBJECT): BOOLEAN is
			-- Collision detection between two banks
		once
			-- Two banks never collide...
			Result := False
		end

	obj_list: DS_LINKED_LIST[Q_OBJECT]
	
	fun_list: ARRAY2[FUNCTION[ANY, TUPLE[Q_OBJECT, Q_OBJECT], BOOLEAN]]

end -- class Q_PHYS_COLLISION_DETECTOR
