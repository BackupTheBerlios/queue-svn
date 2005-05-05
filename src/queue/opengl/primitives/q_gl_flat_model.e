indexing
	description: "A concrete model implemented as a list of faces"
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_FLAT_MODEL

inherit
	Q_GL_MODEL

create
	make

feature
	make (number_vertices:INTEGER) is
			-- creation routine
		do
			create vertices.make(0,2)
		end

feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
		end		

feature
	vertices:ARRAY[Q_GL_VERTEX]
			-- vertices

end -- class Q_GL_FLAT_MODEL
