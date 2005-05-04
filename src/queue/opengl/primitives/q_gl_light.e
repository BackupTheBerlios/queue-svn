indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_GL_LIGHT

inherit
	Q_GL_LIVABLE

feature{NONE}
	make is
		local
			random_ : RANDOM
		do
			hash_code := random_.next_random( 1 )
		end
	
	random : RANDOM once
		do
			create result.make	
		end

feature -- deferreds
	hash_code : INTEGER
		
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			
		end
	
	death( open_gl : Q_GL_DRAWABLE ) is
		do
			
		end
		

end -- class Q_GL_LIGHT
