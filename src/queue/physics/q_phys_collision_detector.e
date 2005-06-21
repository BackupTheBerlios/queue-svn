indexing
	description: "Collision detector, centralized design. (Handle all detections here, not in the bounding boxes)"
	author: "Andreas Kaegi"

class
	Q_PHYS_COLLISION_DETECTOR

create
	make
	
feature -- interface

	make is
			-- Create detector. 
			-- Initialize function list for the various bounding box types.
		do
			create active_list.make
			create passive_list.make
			create remove_list.make
			create fun_list.make(2, 2)
			
			fun_list.put(agent does_collide_circle_circle, 1, 1)
			fun_list.put(agent does_collide_circle_line, 1, 2)
			fun_list.put(agent does_collide_circle_line, 2, 1)
			fun_list.put(agent does_collide_always_false, 2, 2)
			
		end
		
	add_active_object (o: Q_OBJECT) is
			-- Add object 'o' as active object.
			-- Collision is detected between active/active and active/passive objects but not
			-- between twopassive objects.
		require
			o /= void
		do
			active_list.put_first (o)
		end
		
	add_passive_object (o: Q_OBJECT) is
			-- Add object 'o' as passive object.
			--- Collision is detected between active/active and active/passive objects but not
			-- between twopassive objects.
		require
			o /= void
		do
			passive_list.put_first (o)
		end
		
	remove_object (o: Q_OBJECT) is
			-- Remove collision detection support for object 'o'.
			-- Remove object from both active and passive lists.
		do
			remove_list.put_first (o)
		end
		
	remove_all_objects is
			-- Remove all objects from collision detection
		do
			active_list.wipe_out
			passive_list.wipe_out
		end
		
	collision_test (static_test: BOOLEAN): BOOLEAN is
			-- Check if any element collides with any other element.
			-- Static test: Use collision test outside of simulation.
		local
			cursor1, cursor2: DS_LINKED_LIST_CURSOR [Q_OBJECT]
			item1, item2: Q_OBJECT
		do
			-- active/passive
			create cursor1.make (active_list)
			create cursor2.make (passive_list)
			from 
				cursor1.start
			until
				cursor1.off
			loop
				from
					cursor2.start
				until
					cursor2.off
				loop
					item1 := cursor1.item
					item2 := cursor2.item
					
					if (not item1.is_stationary) or else (not item2.is_stationary) then
						if does_collide (item1.bounding_object, item2.bounding_object) then
							result := True
						
							if response_handler /= void then
								response_handler.on_collide (item1, item2)	
							end
						end
						
					end
					cursor2.forth
				end
				cursor1.forth
			end
			
			-- active/active
			create cursor1.make (active_list)
			create cursor2.make (passive_list)
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
					item1 := cursor1.item
					item2 := cursor2.item
					
					if (not item1.is_stationary) or (not item2.is_stationary) then
						if does_collide (item1.bounding_object, item2.bounding_object) then
							result := True
							
							if response_handler /= void then
								response_handler.on_collide (item1, item2)	
							end
						end
					end
					cursor2.forth
				end
				cursor1.forth
			end
			
			-- remove objects from list after all collision tests
			create cursor1.make (remove_list)
			from
				cursor1.start
			until
				cursor1.off
			loop
				active_list.delete (cursor1.item)
				passive_list.delete (cursor1.item)
				cursor1.forth
			end
		end
		
	set_response_handler (h: Q_PHYS_COLLISION_RESPONSE_HANDLER) is
			-- Set a new response handler or null.
		do
			response_handler := h
		end
		
		
feature {NONE} -- implementation

	does_collide (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Does 'o1' collide with 'o2'?
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
			-- Does circle 'o1' collide with circle 'o2'?
		local
			c1, c2: Q_BOUNDING_CIRCLE
			dist: DOUBLE
		do
			c1 ?= o1
			c2 ?= o2
			
			dist := c1.center.distance_square (c2.center)
			
			result := dist <= (c1.radius + c2.radius)^2			
		end
		
	does_collide_circle_line (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Does circle 'o1' collide with line 'o2'?
		local
			circle: Q_BOUNDING_CIRCLE
			line: Q_BOUNDING_LINE
			p: Q_VECTOR_2D
		do
			circle ?= o1
			line ?= o2
			
--			track := circle.center - circle.center_old
--			
--			proj := track.projection (line.edge1 - circle.center)
--			proj_old := track.projection (line.edge1 - circle.center_old)
--			
--			if proj_old.x /= 0 then
--				k := proj.x / proj_old.x
--			else
--				k := proj.y / proj_old.y
--			end
--			
--			result := k <= 0
			
--			create p.make_from_other (circle.velocity)
			p := circle.center - circle.center_old
			p.scale_to (circle.radius)
			p.add (circle.center)
			
			result := line.intersect (circle.center_old, p)
			
		end
		
	does_collide_always_false (o1, o2: Q_BOUNDING_OBJECT): BOOLEAN is
			-- Does 'o1' collide with 'o2'? --> No!
		once
			-- These two objects never collide
			result := false
		end


feature {NONE} -- implementation

	active_list: DS_LINKED_LIST[Q_OBJECT]
	passive_list: DS_LINKED_LIST[Q_OBJECT]
	remove_list: DS_LINKED_LIST[Q_OBJECT]
	
	dmath: DOUBLE_MATH is
		once
			result := create {DOUBLE_MATH}
		end
		
	fun_list: ARRAY2[FUNCTION[ANY, TUPLE[Q_BOUNDING_OBJECT, Q_BOUNDING_OBJECT], BOOLEAN]]

	response_handler: Q_PHYS_COLLISION_RESPONSE_HANDLER
	
	profiler: Q_PROFILER
	
end -- class Q_PHYS_COLLISION_DETECTOR
