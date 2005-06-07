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
		
	new (table: Q_TABLE ; shot: Q_SHOT) is
			-- Start a new simulation.
		require
			table /= void
		local
			arr: ARRAY[Q_OBJECT]
			i: INTEGER
		do
			oldticks := timer_funcs.sdl_get_ticks_external
			
			-- add balls
			arr := table.balls
			arr.do_all (agent addto_detector)
			
			-- add banks
			arr := table.banks
			arr.do_all (agent addto_detector)

		end
		
	step (table: Q_TABLE) is
			-- Compute one step of the current simulation.
		require
			table /= void
		local
			newticks, stepsize: INTEGER
			stepd: DOUBLE
			arr: ARRAY[Q_OBJECT]
		do
			newticks := timer_funcs.sdl_get_ticks_external
			stepsize := newticks - oldticks
			stepd := stepsize / 1000
			oldticks := newticks
			
			-- update objects
			arr := table.balls
			arr.do_all (agent update_position(?, stepd))

			arr := table.banks
			arr.do_all (agent update_position(?, stepd))

			-- collision detection
			collision_detector.collision_test
		end
		
	has_finished: BOOLEAN is
			-- Has current simulation finished?
		do
			result := False
		end
		
	position_list: DS_LINKED_LIST[Q_VECTOR_2D] is
		do
			result := collision_handler.position_list
		end
		
	cue_vector_for_collision(ball_: Q_BALL; velocity_after_collision: Q_VECTOR_2D): Q_VECTOR_2D is
			-- Compute the velocity of the cue ball so that ball_ has a given velocity vector
			-- after a collision cue / ball_
			-- return void if there is no such collision
		do
			-- implemented by physics engine
		end
		
	collision_list : LIST[Q_COLLISION_EVENT] is
			-- the list of all collisions since last start of the simulation, is called from Q_SHOT_STATE
		do
			-- implemented by physics engine
		end
		

feature {NONE} -- implementation

	addto_detector (o: Q_OBJECT) is
			-- Add object 'o' to collsion detecter's list.
		require
			o /= void
		do
			collision_detector.add_object (o)
		end
		
	update_position (o: Q_OBJECT; stepsize: DOUBLE) is
			-- Update position of object 'o'.
		require
			o /= void
		do
			o.update_position (stepsize)
		end
		

	collision_detector: Q_PHYS_COLLISION_DETECTOR
	
	collision_handler: Q_PHYS_COLLISION_RESPONSE_HANDLER
	
	oldticks: INTEGER

	timer_funcs: SDL_TIMER_FUNCTIONS_EXTERNAL is
			-- sdl timer functions, directly used, sorry Benno :-p
		once
			create Result
		end
		
end -- class SIMULATION
