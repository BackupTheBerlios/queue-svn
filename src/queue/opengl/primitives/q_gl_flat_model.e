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
		local
			gl_ : GL_FUNCTIONS
			
			index_:INTEGER
			v_: Q_GL_VERTEX
		do
			gl_ := open_gl.gl

			gl_.gl_color3f( 1, 0, 0 )
			
			from
				index_ := 0
			until
				index_ >= vertices.count
			loop
				-- set normal
				v_ := vertices.item(index_)
				gl_.gl_normal3d (v_.nx, v_.ny, v_.nz)
				
				-- set vector
				gl_.gl_begin( open_gl.gl_constants.esdl_gl_polygon )
				v_ := vertices.item (index_)
				gl_.gl_vertex3d(v_.x, v_.y, v_.z)
				v_ := vertices.item(index_ + 1)
				gl_.gl_vertex3d(v_.x, v_.y, v_.z)
				v_ := vertices.item(index_ + 2)
				gl_.gl_vertex3d(v_.x, v_.y, v_.z)
				gl_.gl_end
				
				index_ := index_ + 3
			end
		end		

feature
	vertices:ARRAY[Q_GL_VERTEX]
			-- vertices

end -- class Q_GL_FLAT_MODEL
