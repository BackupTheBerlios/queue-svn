indexing
	description: "A letter to be part of Q_HUD_IMAGE_FONT"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_IMAGE_LETTER

creation
	make

feature{NONE} -- creation
	make( x_texture_, y_texture_, width_texture_, height_texture_, width_, height_, base_, texture_id_ : INTEGER ) is
		do
			x_texture := x_texture_
			y_texture := y_texture_
			width_texture := width_texture_
			height_texture := height_texture_
			width := width_
			height := height_
			base := base_
			texture_id := texture_id_
		end
		

feature -- draw
	draw( x_, base_, factor_ : DOUBLE; open_gl : Q_GL_DRAWABLE; image_width_, image_height_ : INTEGER ) is
			-- draws this letter
		require
			open_gl_not_void : open_gl /= void
		do

			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_texture_2d )
			
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
			open_gl.gl.gl_color3f( 1, 1, 1 )
			
			open_gl.gl.gl_tex_coord4i( x_texture, y_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_, base_ - factor_ * (height - base) )

			open_gl.gl.gl_tex_coord4i( x_texture + width_texture, y_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_ + factor_*width, base_ - factor_ * (height - base) )

			open_gl.gl.gl_tex_coord4i( x_texture + width_texture, y_texture + height_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_ + factor_*width, base_ + factor_ * base )

			open_gl.gl.gl_tex_coord4i( x_texture, y_texture + height_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_, base_ + factor_ * base )
			
			open_gl.gl.gl_end
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_texture_2d )
		end
		

feature -- information
	texture_id : INTEGER
		-- id of the texture to use
	
	x_texture, y_texture, width_texture, height_texture : INTEGER
		-- position of the Letter on the texture
		
	width, height, base : INTEGER
		-- the real size of the letter. Base is the position of the baseline, measured from the bottom of the letter

end -- class Q_HUD_IMAGE_LETTER
