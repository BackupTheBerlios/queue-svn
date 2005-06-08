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
		
			-- set defaults
			width := 640
			height := 480
			resolution := 24
			fullscreen := false
		
			read_ini_file
			
			video_subsystem.set_video_surface_width (width)
			video_subsystem.set_video_surface_height (height)
			video_subsystem.set_video_bpp (resolution)
			video_subsystem.set_opengl (true)
			video_subsystem.set_fullscreen ( fullscreen )
			initialize_screen
			set_application_name ("Queue OpenGL Proof of Concept")
		
			-- Create ressources
			create ressources.make( current )
		
			-- Create the event_queue
			create event_queue.make( event_loop, video_subsystem )
			
			-- create first state
			state := create {Q_ESCAPE_STATE}.make( false )
			state.install( ressources )
			
			-- Set and launch the first scene.
			set_scene( current )
			launch
		end
	
	read_ini_file is
			-- read the games ini file
		local
			ini_file: PLAIN_TEXT_FILE
			ini_reader: Q_INI_FILE_READER
			
			setting: STRING
		do
			create ini_file.make_open_read ("data/queue.ini")
			
			if ini_file.exists then
				create ini_reader.make
			
				ini_reader.load_ini_file (ini_file)
				
				-- take the settings
				setting := ini_reader.value ("ESDL", "width")
				if setting /= void and then not setting.is_empty then
					width := setting.to_integer
				end
				
				setting := ini_reader.value ("ESDL", "height")
				if setting /= void and then not setting.is_empty then
					height := setting.to_integer
				end
				
				setting := ini_reader.value ("ESDL", "fullscreen")
				if setting /= void and then not setting.is_empty then
					fullscreen := setting.to_boolean
				end
				
				setting := ini_reader.value ("ESDL", "resolution")
				if setting /= void and then not setting.is_empty then
					resolution := setting.to_integer
				end				
			end
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
			ressources.time.restart
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
	width: INTEGER
		-- The width of the surface
		
	height: INTEGER
		-- The height of the surface
		
	resolution: INTEGER
		-- The resolution of the surface
		
	fullscreen: BOOLEAN

invariant
	invariant_clause: True -- Your invariant here

end -- class Q_GAME_LOGIC
