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
	description: "A list of often needed functions"
	author: "Benjamin Sigg"

deferred class
	Q_GL_DRAWABLE

feature -- OpenGL
    gl : GL_FUNCTIONS is deferred
    	ensure
    		gl_not_void : result /= void
    end
	glu : GLU_FUNCTIONS is deferred 
		ensure
			glu_not_void : result /= void
	end
	
	gl_constants : ESDL_GL_CONSTANTS is deferred
		ensure
			gl_constants_not_void : result /= void
	end
	
	glu_constants : ESDL_GLU_CONSTANTS is deferred
		ensure
			glu_constants_not_void : result /= void
	end
	
	live_manager : Q_GL_LIVE_MANAGER is deferred
		ensure
			live_manager_not_void : result /= void
	end
	
	time : Q_TIME is
		deferred
		ensure
			result /= void
		end
		

end -- class Q_GL_DRAWABLE
