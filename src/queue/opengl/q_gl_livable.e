indexing
	description: "Object that can die. On every call of draw, the livable must call the alive-feature of the live-manager. If the livable does not call the feature, its death-feature will be called, after all other Q_GL_OBJECTS are drawed"
	author: "Benjamin Sigg"

deferred class
	Q_GL_LIVABLE

inherit
	Q_GL_OBJECT
	HASHABLE

feature -- death
	death( open_gl : Q_GL_DRAWABLE ) is
			-- Is called, when the LIVABLE has not called the alive-feature of the live-manager
		require
			open_gl_not_void : open_gl /= void
		deferred
		end
		

end -- class Q_GL_LIVABLE
