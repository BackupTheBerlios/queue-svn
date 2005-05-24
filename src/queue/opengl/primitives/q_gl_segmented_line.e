indexing
	description: "A segmented line in the 3d space."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/24 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_SEGMENTED_LINE

inherit
	Q_GL_OBJECT
	
	ARRAY[Q_VECTOR_3D]
	rename make as make_array
	undefine
		copy,
		is_equal
	end

create
	make, make_with_material

feature {NONE} -- contructors
	make (lower_, upper_ : INTEGER) is
			-- make a list with a given capacity
		do
			make_array (lower_, upper_)
			
			create material.make_empty
		end
		
	make_with_material (lower_, upper_ : INTEGER; material_ : Q_GL_MATERIAL) is
			-- make a list with a given capacity
		require
			material_ /= void
		do
			make_array (lower_, upper_)
			
			material := material_
		end
	
feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl : GL_FUNCTIONS
			
			index_ : INTEGER
		do
			gl := open_gl.gl
			
			gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )

			from
				index_ := lower
			until
				index_ > upper
			loop
				gl.gl_vertex3d (item (index_).x, item (index_).y, item (index_).z)
			end
			
			gl.gl_end
		end
		
feature -- access
	material : Q_GL_MATERIAL
	
invariant
	material /= void
	
end -- class Q_GL_SEGMENTED_LINE