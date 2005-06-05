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

feature {NONE}
	make (number_vertices:INTEGER) is
			-- creation routine
		do
			create vertices.make(0,2)
		end

feature -- setters
	set_material (new_material : Q_GL_MATERIAL) is
			-- Set a new material for the model.
		require
			new_material /= void
		do
			material := new_material
		ensure
			material = new_material
		end
		
	set_diffuse_texture (new_texture : Q_GL_TEXTURE) is
			-- Set a new diffuse texture for the model.
		require
			new_texture /= void
		do
			diffuse_texture := new_texture
		ensure
			diffuse_texture = new_texture
		end

feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			gl_ : GL_FUNCTIONS
			
			index_:INTEGER
			v_: Q_GL_VERTEX
		do
			gl_ := open_gl.gl
			
			gl_.gl_shade_model (open_gl.gl_constants.esdl_gl_smooth)
			gl_.gl_enable (open_gl.gl_constants.esdl_gl_color_material)
			
			material.set ( open_gl )
			
			if diffuse_texture /= void then
				diffuse_texture.transform (open_gl)	
			end
			
			from
				index_ := 0
			until
				index_ >= vertices.count
			loop
				gl_.gl_begin( open_gl.gl_constants.esdl_gl_polygon )
				
				v_ := vertices.item (index_)
				gl_.gl_tex_coord2d (v_.tu, v_.tv)
				gl_.gl_normal3d (v_.nx, v_.ny, v_.nz)
				gl_.gl_vertex3d (v_.x, v_.y, v_.z)
				
				v_ := vertices.item(index_ + 1)
				gl_.gl_tex_coord2d (v_.tu, v_.tv)
				gl_.gl_normal3d (v_.nx, v_.ny, v_.nz)
				gl_.gl_vertex3d (v_.x, v_.y, v_.z)
				
				v_ := vertices.item(index_ + 2)
				gl_.gl_tex_coord2d (v_.tu, v_.tv)
				gl_.gl_normal3d (v_.nx, v_.ny, v_.nz)
				gl_.gl_vertex3d (v_.x, v_.y, v_.z)
				
				gl_.gl_end
				
				index_ := index_ + 3
			end
			
			if diffuse_texture /= void then
				diffuse_texture.untransform (open_gl)
			end
			
			gl_.gl_disable (open_gl.gl_constants.esdl_gl_color_material)
		end		

feature
	vertices:ARRAY[Q_GL_VERTEX]
			-- vertices
			
	material : Q_GL_MATERIAL
	
	diffuse_texture : Q_GL_TEXTURE

end -- class Q_GL_FLAT_MODEL
