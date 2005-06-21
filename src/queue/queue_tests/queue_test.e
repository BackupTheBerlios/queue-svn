--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

indexing

	description: "Test class"

class

	QUEUE_TEST

inherit

	ESDL_APPLICATION

create
	
	make
	
feature {NONE} -- Initialization
	
	make is
			-- Create the main application.
		local
			scene_ : Q_TEST_CASE_SCENE
			gl: Q_GAME_LOGIC
		do
			video_subsystem.set_video_surface_width (width)
			video_subsystem.set_video_surface_height (height)
			video_subsystem.set_video_bpp (resolution)
			video_subsystem.set_opengl (true)
			
			initialize_screen
			set_application_name ("Queue OpenGL Proof of Concept")
			
			-- Create first scene.
			create scene_.make_scene( video_subsystem )

			-- Set and launch the first scene.
			set_scene ( scene_ )
			launch
		end
		

feature {NONE} -- Implementation
		
	width: INTEGER is 640 -- 512
		-- The width of the surface
		
	height: INTEGER is 480 -- 512
		-- The height of the surface
		
	resolution: INTEGER is 24
		-- The resolution of the surface

end
