indexing
	description: "A line in the 3d space."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/24 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_LINE

inherit
	Q_GL_OBJECT

create
	make_position_material
	
feature {NONE} -- creation
	make_position_material (start_, stop_: Q_VECTOR_3D; material_: Q_GL_MATERIAL) is
			-- create a line with a material
		do
			start := start_
			stop := stop_
			material := material_
		end
		

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl : GL_FUNCTIONS
		do
			gl := open_gl.gl
			
			gl.gl_begin( open_gl.gl_constants.esdl_gl_line )

			material.set (open_gl )

			-- start
			gl.gl_vertex3d (start.x, start.y, start.z)
			-- end
			gl.gl_vertex3d (stop.x, stop.y, stop.z)
			
			gl.gl_end
		end
		
feature -- access
	start, stop : Q_VECTOR_3D
	
	material : Q_GL_MATERIAL
	
invariant
	start /= void
	stop /= void
	material /= void
	
end -- class Q_GL_LINE
