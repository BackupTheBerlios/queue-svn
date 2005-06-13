indexing
	description: "A Component allowing to set a select/unselect-state"
	author: "Benjamin Sigg"

class
	Q_HUD_CHECK_BOX

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
			precursor()

			set_background_normal( color_defaults.color_of( "checkbox", "normal" ))
			set_background_pressed( color_defaults.color_of( "checkbox", "pressed" ))
			set_background_rollover( color_defaults.color_of( "checkbox", "rollover" ))
			set_foreground( color_defaults.color_of( "checkbox", "foreground" ))
			
			set_blend_background( color_defaults.blend( "checkbox") )
			
			set_font( font_defaults.font( "checkbox" ))
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
				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_triangles )
				
				open_gl.gl.gl_vertex2d( x_ + 0.2*width_, y_ + 0.55*height_ )
				open_gl.gl.gl_vertex2d( x_ + 0.6*width_, y_ + 0.9*height_ )
				open_gl.gl.gl_vertex2d( x_ + 0.5*width_, y_ + 0.7*height_ )
				
				open_gl.gl.gl_vertex2d( x_ + 0.8*width_, y_ + 0.2*height_ )
				open_gl.gl.gl_vertex2d( x_ + 0.5*width_, y_ + 0.7*height_ )
				open_gl.gl.gl_vertex2d( x_ + 0.6*width_, y_ + 0.9*height_ )
				
				open_gl.gl.gl_end
			end
		end
end -- class Q_HUD_CHECK_BOX
