indexing
	description: "Has the ability to self-draw it on a 3D-Opengl-Drawable"
	author: "Benjamin Sigg"

deferred class
	Q_GL_OBJECT

feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
			-- draws this visualisation
		require
			open_gl_not_void : open_gl /= void
			
		deferred
		end
end -- class Q_GL_OBJECT
