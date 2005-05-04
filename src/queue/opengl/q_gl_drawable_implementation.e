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
		end
		

feature -- all
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
