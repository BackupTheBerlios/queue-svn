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
	description: "A Button with a selcted/unselected state"
	author: "Benjamin Sigg"

class
	Q_HUD_RADIO_BUTTON

inherit
	Q_HUD_SELECTABLE_BUTTON
	redefine
		make
	end

creation
	make

feature {NONE} -- Creation
	make is
		do
			precursor
			
			set_background_normal( color_defaults.color_of( "radiobutton", "normal" ))
			set_background_pressed( color_defaults.color_of( "radiobutton", "pressed" ))
			set_background_rollover( color_defaults.color_of( "radiobutton", "rollover" ))
			set_foreground( color_defaults.color_of( "radiobutton", "foreground" ))
			
			set_blend_background( color_defaults.blend( "radiobutton"))
			
			set_font( font_defaults.font( "radiobutton" ))
		end
		
feature -- drawing
	draw_box( open_gl : Q_GL_DRAWABLE; width__, height__ : DOUBLE ) is
			-- draws the box in the rectangle 0, 0, width_, height_
		local
			x_, y_, width_, height_ : DOUBLE
		do
			x_ := 0.1 * width__
			y_ := 0.1 * height__
			width_ := 0.8 * width__
			height_ := 0.8 * height__
			
			-- set color of box
			if foreground = void then
				open_gl.gl.gl_color3f( 0, 0, 0 )
			else
				foreground.set( open_gl )
			end
			
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_lines )
			
			open_gl.gl.gl_vertex2d( x_, y_ )
			open_gl.gl.gl_vertex2d( x_ + width_, y_ )
			
			open_gl.gl.gl_vertex2d( x_ + width_, y_ )
			open_gl.gl.gl_vertex2d( x_ + width_, y_ + height_ )

			open_gl.gl.gl_vertex2d( x_ + width_, y_ + height_ )
			open_gl.gl.gl_vertex2d( x_ , y_ + height_ )
			
			open_gl.gl.gl_vertex2d( x_ , y_ + height_ )
			open_gl.gl.gl_vertex2d( x_ , y_ )
			
			open_gl.gl.gl_end
			
			if selected then
				-- draw the mark for selection
				open_gl.gl.gl_rectd(
					x_ + 0.1 * width_, 
					y_ + 0.1 * height_, 
					x_ + 0.9 * width_,
					y_ + 0.9 * height_ )
			end
		end
end -- class Q_HUD_RADIO_BUTTON
