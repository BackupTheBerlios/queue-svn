indexing
	description: "This is the root class of the project. It contains the game loop."
	author: "Severin Hacker"

class
	Q_GAME_LOGIC

inherit
	ESDL_APPLICATION
	undefine
		default_create
	end
	ESDL_SCENE
	rename
		screen as scene_screen
	redefine
		redraw
	end
	
create
	make

feature -- Interface

	initialize_scene is
		do
			
		end
		
feature{NONE} -- creation
	make is
			-- the creation procedure of the root class, creates the event_queue and others
		do
			default_create
			
			video_subsystem.set_video_surface_width (width)
			video_subsystem.set_video_surface_height (height)
			video_subsystem.set_video_bpp (resolution)
			video_subsystem.set_opengl (true)
			initialize_screen
			set_application_name ("Queue OpenGL Proof of Concept")
		
			-- Create ressources
			create ressources.make( current )
		
			-- Create the event_queue
			create event_queue.make( event_loop, video_subsystem )
			
			-- create first state
			state := create {Q_ESCAPE_STATE}.make
			state.install( ressources )
			
			-- Set and launch the first scene.
			set_scene( current )
			launch
		end
		
	
feature {NONE} -- THE game loop
	
	redraw is
			-- this is the main game loop. loops as long as needed, processes I/O, controls
			-- the graphics, the physics and AI engine.
		local
			next_ : Q_GAME_STATE
		do
			-- Process I/O
			ressources.gl_manager.process( event_queue )
				
			-- Manage states
			state.step( ressources )
			next_ := state.next( ressources )
				
			if next_ /= void then
				state.uninstall( ressources )
				state := next_
				state.install( ressources )
			end
				
			-- Render
			ressources.gl_manager.draw

			screen.redraw				
		end
		
	state : Q_GAME_STATE -- the state of the loop and the program
	
	ressources : Q_GAME_RESSOURCES 

	event_queue : Q_EVENT_QUEUE
		-- the real event-queue

feature {NONE} -- other
	width: INTEGER is 640
		-- The width of the surface
		
	height: INTEGER is 480
		-- The height of the surface
		
	resolution: INTEGER is 24
		-- The resolution of the surface

invariant
	invariant_clause: True -- Your invariant here

end -- class Q_GAME_LOGIC
