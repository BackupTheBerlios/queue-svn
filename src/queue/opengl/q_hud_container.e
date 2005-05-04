indexing
	description: "Contains one or many Q_HUD_COMPONENTS. The coordinate-system of this components is translated by the container"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HUD_CONTAINER

inherit
	Q_HUD_COMPONENT
	undefine
		copy, is_equal
	end
	
	LINKED_LIST[ Q_HUD_COMPONENT ]

creation
	make

feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			component_ : Q_HUD_COMPONENT
		do
			from
				start
			until
				after
			loop
				component_ := item
				
				open_gl.gl.gl_push_matrix
				
				open_gl.gl.gl_translated( component_.x, component_.y, 0 )
				component_.draw( open_gl )
				
				open_gl.gl.gl_pop_matrix
			end
		end
		

end -- class Q_HUD_CONTAINER
