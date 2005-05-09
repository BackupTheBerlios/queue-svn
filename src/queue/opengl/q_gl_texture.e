indexing
	description: "A texture: a bitmap drawn on polygons"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_GL_TEXTURE
inherit
	Q_GL_TRANSFORM
	
creation
	make
	
feature {NONE} -- creation
	make( file_ : STRING ) is
			-- creates a new texture from a file
		require
			file_not_void : file_ /= void
		local
			shared_factory_ : ESDL_SHARED_BITMAP_FACTORY
			factory_ : ESDL_BITMAP_FACTORY
		do
			create shared_factory_
			factory_ := shared_factory_.bitmap_factory
			factory_.create_bitmap_from_image( file_ )
			image := factory_.last_bitmap
			
			id := image.gl_texture_mipmap
		end
		
feature -- Informations
	image : ESDL_BITMAP
		-- the bitmap user for this texture

	id : INTEGER 
		-- texture-id

	width : INTEGER is
			-- Width of the texture. Equal to "image.width"
		do
			result := image.width
		end
		
	height : INTEGER is
			-- Height of the texture. Equal to "image.height"
		do
			result := image.height
		end
		
		
feature -- Transform
	transform( open_gl : Q_GL_DRAWABLE ) is
			-- enables 2d-textures, and binds this texture
		do
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_texture_2d )
			open_gl.gl.gl_bind_texture( open_gl.gl_constants.esdl_gl_texture_2d, id )
		end
		
	untransform( open_gl : Q_GL_DRAWABLE ) is
			-- disables 2d textures
		do
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_texture_2d )
		end
		
		

end -- class Q_GL_TEXTURE
