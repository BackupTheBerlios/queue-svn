indexing
	description: "Main class of the physics cluster. Called by the game loop."
	author: "Andreas Kaegi"

class
	Q_SIMULATION

create
	make

feature -- create

	make is
			-- Create object.
		do
			create collision_detector.make
			create collision_handler.make (collision_detector)
			
			collision_detector.set_response_handler (collision_handler)
		end
		
		
feature -- interface
		
	new (table: Q_TABLE; shot: Q_SHOT) is
			-- Start a new simulation.
		require
			table /= Void
			shot /= Void
		local
			arr: ARRAY[Q_OBJECT]
			i: INTEGER
			b: Q_BANK
		do
			oldticks := timer_funcs.sdl_get_ticks_external

			shot.hitball.set_velocity (shot.direction)
			
			-- empty list of collision detector
			collision_detector.remove_all_objects
			
			-- empty collision list
			-- DO I REALLY HAVE TO DO THIS, SEVERIN?
			collision_handler.collision_list.wipe_out
			
--			collision_detector.add_object (table.balls.item (0))
			-- add balls
			arr := table.balls
			arr.do_all (agent addto_detector)

			-- add banks
			arr := table.banks
			arr.do_all (agent addto_detector)
			
			-- START DEBUG --
			from
				i := arr.lower
			until
				i > arr.upper
			loop
				b ?= arr @ i
				
				io.putstring ("banks.put (create bank.make (create {Q_VECTOR_2D}.make (")
				io.putdouble (b.edge1.x)
				io.putstring (", ")
				io.putdouble (b.edge1.y)
				io.putstring ("), create {Q_VECTOR_2D}.make (")
				io.putdouble (b.edge2.x)
				io.putstring (", ")
				io.putdouble (b.edge2.y)
				io.putstring (")), ")
				io.putint (i)
				io.putstring (")")
				io.put_new_line
				
				i := i + 1	
			end
			
			-- END DEBUG --

		end
		
	step (table: Q_TABLE; time: Q_TIME) is
			-- Compute one step of the current simulation.
		require
			table /= void
		local
			newticks, stepsize: INTEGER
			stepd: DOUBLE
			i, j: INTEGER
			b: BOOLEAN
		do
			if is_test then
				newticks := timer_funcs.sdl_get_ticks_external
				stepsize := newticks - oldticks
				stepd := stepsize / 1000
				oldticks := newticks
			else
				stepd := time.delta_time_millis / 1000
			end
			
			stepd := stepd / steps_per_frame
			
			from i := 0
			until
				i >= steps_per_frame
			loop		
				-- update objects
--				table.balls.item (0).do_update_position (stepd)
				table.balls.do_all (agent do_update_position(?, stepd))
				
				-- balls standing still?
				from 
					finished := true
					j := table.balls.lower
				until
					(finished = false) or (j > table.balls.upper)
				loop
					finished := finished and (table.balls.item (j).is_stationary)
					j := j + 1
				end
				
				-- collision detection
				collision_detector.set_response_handler (collision_handler)
				b := collision_detector.collision_test -- (stepd)
				
				i := i + 1
			end -- from (step)
		end
		
	has_finished: BOOLEAN is
			-- Has current simulation finished?
		do
			result := finished
		end
		
	cue_vector_for_collision (b: Q_BALL; velocity_after_collision: Q_VECTOR_2D): Q_VECTOR_2D is
			-- Compute the velocity of the cue ball so that ball b has a given velocity vector
			-- after a collision cue / ball
			-- Return Void if there is no such collision
		do
			-- implemented by physics engine
		end
		
	collision_list: LIST[Q_COLLISION_EVENT] is
			-- List of all collisions since last start of the simulation, called by Q_SHOT_STATE
		do
			Result := collision_handler.collision_list
		end
		
	collision_detector: Q_PHYS_COLLISION_DETECTOR
	
	collision_handler: Q_PHYS_COLLISION_RESPONSE_HANDLER

feature {NONE} -- implementation

	addto_detector (o: Q_OBJECT) is
			-- Add object 'o' to collsion detecter's list.
		require
			o /= void
		do
			collision_detector.add_object (o)
		end
		
	do_update_position (b: Q_BALL; stepsize: DOUBLE) is
			-- Update position of object 'o'.
		require
			b /= void
		do
			b.do_update_position (stepsize)
		end
	
	oldticks: INTEGER
	
	finished: BOOLEAN

	timer_funcs: SDL_TIMER_FUNCTIONS_EXTERNAL is
			-- sdl timer functions, directly used, sorry Benno :-p
		once
			create result
		end
		
	steps_per_frame: INTEGER is 3
		
	-- START DEBUG --
	is_test: BOOLEAN is False
	-- END DEBUG --
		
end -- class SIMULATION
