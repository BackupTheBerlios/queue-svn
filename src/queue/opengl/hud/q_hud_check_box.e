indexing
	description: "A Component allowing to set a select/unselect-state"
	author: "Benjamin Sigg"

class
	Q_HUD_CHECK_BOX

inherit
	Q_HUD_TEXTED
	redefine
		draw_foreground
	end

creation
	make

feature {NONE} -- Creation
	make is
		do
			default_create

			set_background( create {Q_GL_COLOR}.make_cyan )
			
			set_alignement_x( 0.0 )
			set_alignement_y( 0.5 )
			
			set_enabled( true )
			set_focusable( true )
		end
		
feature -- drawing
	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		local
			insets_, old_insets_ : Q_HUD_INSETS
			box_height_, box_width_ : DOUBLE
		do
			-- maximal width and height of the box
			box_height_ := height
			box_width_ := box_height_.min( width / 2 )
			
			-- draw the text
			old_insets_ := insets
							
			if insets = void then
				create insets_.make( 0, 0, 0, 0 )
			else
				create insets_.make_copy( insets )
			end
			
			insets_.set_left( insets_.left + box_width_ / width  )
			set_insets( insets_ )
			precursor( open_gl )
			set_insets( old_insets_ )
			
			-- draw the box
			draw_box( open_gl, box_width_, box_height_ )
		end
		
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
			end
		end
		
		
feature -- Values
	selected : BOOLEAN
	
	set_selected( selected_ : BOOLEAN ) is
		do
			selected := selected_
		end	

end -- class Q_HUD_CHECK_BOX
