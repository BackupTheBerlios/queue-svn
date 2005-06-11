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
			table /= void
		local
			arr: ARRAY[Q_OBJECT]
		do
			oldticks := timer_funcs.sdl_get_ticks_external

			shot.hitball.set_velocity (shot.direction)
			
			-- empty collision list
			-- DO I REALLY HAVE TO DO THIS, SEVERIN?
			collision_handler.collision_list.wipe_out
			
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
		do
			newticks := timer_funcs.sdl_get_ticks_external
			stepsize := newticks - oldticks
			stepd := stepsize / 1000
			oldticks := newticks
			
			-- update objects
			table.balls.do_all (agent do_update_position(?, stepd))

			-- collision detection
			collision_detector.collision_test (stepd)

		end
		
	has_finished: BOOLEAN is
			-- Has current simulation finished?
		do
			result := False
		end
		
	cue_vector_for_collision (b: Q_BALL; velocity_after_collision: Q_VECTOR_2D): Q_VECTOR_2D is
			-- Compute the velocity of the cue ball so that ball b has a given velocity vector
			-- after a collision cue / ball
			-- Return Void if there is no such collision
		do
			-- implemented by physics engine
		end
		
	collision_list: LIST[Q_COLLISION_EVENT] is
			-- List of all collisions since last start of the simulation, called from game logic
		do
			Result := collision_handler.collision_list
		end
		

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
		

	collision_detector: Q_PHYS_COLLISION_DETECTOR
	
	collision_handler: Q_PHYS_COLLISION_RESPONSE_HANDLER
	
	oldticks: INTEGER

	timer_funcs: SDL_TIMER_FUNCTIONS_EXTERNAL is
			-- sdl timer functions, directly used, sorry Benno :-p
		once
			create Result
		end
		
end -- class SIMULATION
