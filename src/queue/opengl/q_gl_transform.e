indexing
	description: "A Transform-object changes different settings of the opengl-Scene"
	author: "Benjamin Sigg"

deferred class
	Q_GL_TRANSFORM
	
feature -- all
	transform( open_gl : Q_GL_DRAWABLE ) is
			-- transforms a drawable. Ex: changing the matrix
		deferred
		ensure
			open_gl_not_void : open_gl /= void
		end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
			-- the opposite of transform. If transform rotate the scene by 45°, then untransform rotate the scene by -45°
		deferred
		ensure
			open_gl_not_void : open_gl /= void
		end

end -- class Q_GL_TRANSFORM
