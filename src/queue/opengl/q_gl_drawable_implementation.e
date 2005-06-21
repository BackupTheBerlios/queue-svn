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
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_GL_DRAWABLE_IMPLEMENTATION

inherit
	Q_GL_DRAWABLE
	
	GL_FUNCTIONS
	
	GLU_FUNCTIONS
	
	ESDL_GL_CONSTANTS
	ESDL_GLU_CONSTANTS
	
creation
	make, make_timed
	
feature{NONE}
	make( live_manager_ : Q_GL_LIVE_MANAGER ) is
		require
			live_manager_not_void : live_manager_ /= void
		do
			create time
			time_extern := false
			live_manager := live_manager_
		end

	make_timed( live_manager_ : Q_GL_LIVE_MANAGER; time_ : Q_TIME ) is
		require
			live_manager_not_void : live_manager_ /= void
		do
			time := time_
			time_extern := true
			live_manager := live_manager_
		end		

feature{NONE}
	time_extern : BOOLEAN

feature -- all
	time : Q_TIME
	
	restart is
		do
			if not time_extern then
				time.restart				
			end
		end
		

	gl : GL_FUNCTIONS is
		do
			result := current
		end
		
	glu : GLU_FUNCTIONS is
		do
			result := current
		end
		
	gl_constants : ESDL_GL_CONSTANTS is
		do
			result := current
		end
		
	glu_constants : ESDL_GLU_CONSTANTS is
		do
			result := current
		end

	live_manager : Q_GL_LIVE_MANAGER
		
end -- class Q_GL_DRAWABLE_IMPLEMENTATION
