indexing
	description: "A group of various transformations"
	author: "Benjamin Sigg"

class
	Q_GL_TRANSFORM_GROUP[Q -> Q_GL_TRANSFORM]

inherit
	Q_GL_TRANSFORM
	undefine
		copy, is_equal
	end
	ARRAYED_LIST[Q]
	
creation
	make

feature -- transformation
	transform( open_gl : Q_GL_DRAWABLE ) is
		do
			from
				start
			until
				after
			loop
				item.transform( open_gl )
				forth
			end
		end
	
	untransform( open_gl : Q_GL_DRAWABLE ) is
		local
			index_ : INTEGER
		do
			from
				index_ := count
			until
				index_ < 0
			loop
				i_th( index_ ).untransform( open_gl )
				index_ := index_ - 1
			end
		end
		

end -- class Q_GL_TRANSFORM_GROUP
