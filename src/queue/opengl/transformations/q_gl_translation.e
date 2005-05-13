indexing
	description: "Represents a translation in the 3d space."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_TRANSLATION

inherit
	Q_GL_TRANSFORM
	redefine
		transform,
		untransform
	end

feature -- all
	transform( open_gl : Q_GL_DRAWABLE ) is
			-- transforms a drawable. Ex: changing the matrix
		do
		end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
			-- the opposite of transform. If transform rotate the scene by 45°, then untransform rotate the scene by -45°
		do
		end

end -- class Q_GL_TRANSLATION
