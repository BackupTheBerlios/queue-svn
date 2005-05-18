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
	make
	
feature{NONE}
	make( live_manager_ : Q_GL_LIVE_MANAGER ) is
		require
			live_manager_not_void : live_manager_ /= void
		do
			live_manager := live_manager_
			last_time := current_time_millis
		end
		

feature -- all
	last_time : INTEGER
	delta_time_millis : INTEGER

	restart is
		local
			time_ : INTEGER
		do
			time_ := current_time_millis
			
			delta_time_millis := time_ - last_time
			last_time := time_
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

	current_time_millis : INTEGER is
		external
			"C [macro <ewg_esdl_function_c_glue_code.h>] :Uint32"
		alias
			"ewg_function_macro_SDL_GetTicks"
		end	
		
end -- class Q_GL_DRAWABLE_IMPLEMENTATION
