indexing
	description: "A group witch has a Q_GL_TRANSFORM to change temporarly some settings"
	author: "Benjamin Sigg"

class
	Q_GL_TRANSFORMED_GROUP[Q -> Q_GL_OBJECT]

inherit
	Q_GL_GROUP[Q]
	redefine
		draw
	end


creation
	make

feature -- all
	transform : Q_GL_TRANSFORM
	
	set_transform( transform_ : Q_GL_TRANSFORM ) is
			-- sets the transformation. This can be void, to use no transformation
		do
			transform := transform_
		end
		
	
feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			if
				transform = void
			then
				precursor( open_gl )
			else
				transform.transform( open_gl )
				precursor( open_gl )
				transform.untransform( open_gl )
			end
		end
		

end -- class Q_GL_TRANSFORM_GROUP
