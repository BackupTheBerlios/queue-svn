--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

indexing
	description: "A letter to be part of Q_HUD_IMAGE_FONT"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_IMAGE_LETTER

creation
	make

feature{NONE} -- creation
	make( x_texture_, y_texture_, width_texture_, height_texture_, width_, height_, base_, space_, texture_id_ : INTEGER ) is
		do
			x_texture := x_texture_
			y_texture := y_texture_
			width_texture := width_texture_
			height_texture := height_texture_
			width := width_
			height := height_
			space := space_
			base := base_
			texture_id := texture_id_
		end
		

feature -- draw
	draw( x_, base_, factor_ : DOUBLE; open_gl : Q_GL_DRAWABLE; image_width_, image_height_ : INTEGER ) is
			-- draws this letter
		require
			open_gl_not_void : open_gl /= void
		do
			open_gl.gl.gl_color3f( 1, 1, 1)

			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_blend )
			open_gl.gl.gl_enable( open_gl.gl_constants.esdl_gl_alpha_test )
		
			open_gl.gl.gl_blend_func( 
				open_gl.gl_constants.esdl_gl_zero, 
				open_gl.gl_constants.esdl_gl_src_color )

			open_gl.gl.gl_alpha_func( 
				open_gl.gl_constants.esdl_gl_notequal, 0 )

			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )

			open_gl.gl.gl_tex_coord4i( x_texture, y_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_, base_ - factor_ * (height - base) )

			open_gl.gl.gl_tex_coord4i( x_texture + width_texture, y_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_ + factor_*width, base_ - factor_ * (height - base) )

			open_gl.gl.gl_tex_coord4i( x_texture + width_texture, y_texture + height_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_ + factor_*width, base_ + factor_ * base )

			open_gl.gl.gl_tex_coord4i( x_texture, y_texture + height_texture, image_width_, image_height_ )
			open_gl.gl.gl_vertex2d( x_, base_ + factor_ * base )
			
			open_gl.gl.gl_end
		
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_alpha_test )
			open_gl.gl.gl_disable( open_gl.gl_constants.esdl_gl_blend )
		end
		

feature -- information
	texture_id : INTEGER
		-- id of the texture to use
	
	x_texture, y_texture, width_texture, height_texture : INTEGER
		-- position of the Letter on the texture
		
	width, height, base, space : INTEGER
		-- the real size of the letter. Base is the position of the baseline, measured from the bottom of the letter

end -- class Q_HUD_IMAGE_LETTER
