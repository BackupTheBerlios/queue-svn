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
