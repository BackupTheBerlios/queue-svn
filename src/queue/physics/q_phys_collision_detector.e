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
			
			fun_list.put(agent does_collide_circle_circle, 1, 1)
			fun_list.put(agent does_collide_circle_line, 1, 2)
			fun_list.put(agent does_collide_circle_line, 2, 1)
			fun_list.put(agent does_collide_always_false, 2, 2)
			
		end
		
	add_object(o: Q_OBJECT) is
			-- Add collision detection support for object o
		require
			o /= void
		do
			obj_list.put_first (o)
		end
		
	remove_object (o: Q_OBJECT) is
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
					if does_collide (cursor1.item.bounding_object, cursor2.item.bounding_object) then
						cursor1.item.on_collide (cursor2.item)
						cursor2.item.on_collide (cursor1.item)
						
						if response_handler /= void then
							response_handler.on_collide (cursor1.item, cursor2.item)	
						end
					end
					cursor2.forth
				end
				cursor1.forth
			end
		end
		
	set_response_handler (h: Q_PHYS_COLLISION_RESPONSE_HANDLER) is
			-- Set a new response handler or null
		do
			response_handler := h
		end
		
		
feature {NONE} -- implementation

	does_collide (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Collision detection between o1 and o2
		local
			f: FUNCTION[ANY, TUPLE[Q_BOUNDING_OBJECT, Q_BOUNDING_OBJECT], BOOLEAN]
			args: TUPLE[Q_BOUNDING_OBJECT, Q_BOUNDING_OBJECT]
		do
			f := fun_list.item (o1.typeid, o2.typeid)
			
			if o1.typeid <= o2.typeid then
				args := [o1, o2]
			else
				args := [o2, o1]
			end

			Result := f.item (args)
		end
		
	does_collide_circle_circle (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Collision detection between two circle bounding boxes
		local
			c1, c2: Q_BOUNDING_CIRCLE
			dist: DOUBLE
		do
			c1 ?= o1
			c2 ?= o2
			
			dist := c1.center.distance (c2.center)
			
			result := dist <= (c1.radius + c2.radius)
		end
		
	does_collide_circle_line (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Collision detection between ball o1 and bank o2
		local
			circle: Q_BOUNDING_CIRCLE
			line: Q_BOUNDING_LINE
			dist: DOUBLE
		do
			circle ?= o1
			line ?= o2
			
			dist := line.distance_vector (circle.center)
			
			result := dist <= circle.radius
		end
		
	does_collide_always_false (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Collision detection between two banks
		once
			-- Theres two objects never collide
			result := false
		end

	obj_list: DS_LINKED_LIST[Q_OBJECT]
	
	fun_list: ARRAY2[FUNCTION[ANY, TUPLE[Q_BOUNDING_OBJECT, Q_BOUNDING_OBJECT], BOOLEAN]]

	response_handler: Q_PHYS_COLLISION_RESPONSE_HANDLER
	
end -- class Q_PHYS_COLLISION_DETECTOR
