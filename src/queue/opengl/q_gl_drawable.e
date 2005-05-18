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

	current_time_millis : INTEGER is
			-- current time in millis
		deferred
		end
	
	delta_time_millis : INTEGER is
			-- Time since last call of the game-loop
		deferred
		end
		

end -- class Q_GL_DRAWABLE
