indexing
	description: "This is the root class of the project. It contains the game loop."
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_GAME_LOGIC

inherit
	ESDL_APPLICATION
	
create
	make

feature -- Interface

	make is
			-- the creation procedure of the root class, creates the event_queue and others
		local
			scene_ : Q_TEST_CASE_SCENE
			eball_mode_ : Q_8BALL
		do
			video_subsystem.set_video_surface_width (width)
			video_subsystem.set_video_surface_height (height)
			video_subsystem.set_video_bpp (resolution)
			video_subsystem.set_opengl (true)
			initialize_screen
			set_application_name ("Queue OpenGL Proof of Concept")
		
			-- Create first scene.
			create scene_.make_scene( video_subsystem )
			scene_.initialize_scene
			
			-- Create the event_queue
			create event_queue.make(scene_.event_loop, video_subsystem)
			
			-- Create the game mode
			create eball_mode_.make
			
			-- Set and launch the first scene.
			set_scene ( scene_ )
			launch
			
			-- Start the game loop
			game_loop
		end
	
		

feature {NONE} -- THE game loop
	
	game_loop is
			-- this is the main game loop. loops as long as needed, processes I/O, controls
			-- the graphics, the physics and AI engine.
		require
			
		do
			from
			until false
			loop
				-- Process I/O

				-- Render
			
			end				
		end
		
	state : INTEGER -- the state of the loop and the program
	
		
feature {NONE} -- game logic
	
	table: Q_TABLE -- the table of the game
	mode : Q_MODE -- the mode of the game
	player_A : Q_PLAYER -- the first player
	player_B : Q_PLAYER -- the second player

feature {NONE} -- physics
	simulation : Q_SIMULATION -- the simulation that computes physical exact collisions and moves
	
feature {NONE} -- graphics
	table_model : Q_TABLE_MODEL -- the table model of the game
	renderer : Q_RENDERER -- the renderer that is used to render updated tables, stats, etc.
	
feature {NONE} -- I/O
	event_queue: Q_EVENT_QUEUE

feature {NONE} -- other
	width: INTEGER is 512
		-- The width of the surface
		
	height: INTEGER is 512
		-- The height of the surface
		
	resolution: INTEGER is 24
		-- The resolution of the surface

invariant
	invariant_clause: True -- Your invariant here

end -- class Q_GAME_LOGIC
