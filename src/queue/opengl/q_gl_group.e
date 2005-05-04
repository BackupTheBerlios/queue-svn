indexing
	description: "Groups one ore more Q_GL_OBJECT to one great object"
	author: "Benjamin Sigg"

class
	Q_GL_GROUP[Q -> Q_GL_OBJECT] inherit 
		Q_GL_OBJECT
		undefine
			copy, is_equal
		redefine
			draw
		end
		LINKED_LIST[Q] 
		
creation
	make

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
	do		
		from
			start
		until
			after
		loop
			item.draw( open_gl )
			forth
		end
	end
		

end -- class Q_GL_GROUP
