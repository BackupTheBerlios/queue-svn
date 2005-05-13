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
			
			set_background_normal( create {Q_GL_COLOR}.make_rgb( 0.5, 1, 0.5 ) )
			set_background_pressed( create {Q_GL_COLOR}.make_rgb( 0.25, 1, 0.25 ) )
			set_background_rollover( create {Q_GL_COLOR}.make_rgb( 0.75, 1, 0.75 ) )
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
