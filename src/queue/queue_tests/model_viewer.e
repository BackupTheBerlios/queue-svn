class MODEL_VIEWER

inherit
	ESDL_APPLICATION

create
	
	make
	
feature {NONE} -- Initialization
	
	make is
			-- Create the main application.
		local
			first_scene: TABLE_SCENE
		do
			video_subsystem.set_video_surface_width (width)
			video_subsystem.set_video_surface_height (height)
			video_subsystem.set_video_bpp (resolution)
			video_subsystem.set_opengl (true)
			initialize_screen
			set_application_name ("Queue OpenGL Proof of Concept")
			
			-- Create first scene.
			create first_scene

			-- Set and launch the first scene.
			set_scene (first_scene)
			launch
		end
		

feature {NONE} -- Implementation
		
	width: INTEGER is 500
		-- The width of the surface
		
	height: INTEGER is 500
		-- The height of the surface
		
	resolution: INTEGER is 24
		-- The resolution of the surface

end