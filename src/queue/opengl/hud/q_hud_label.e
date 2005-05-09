indexing
	description: "Paints a text on the screen"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_LABEL

inherit
	Q_HUD_COMPONENT

creation
	make
	
feature {NONE} -- creation
	make is
		do
			set_alignement_x( 0.0 )
			set_alignement_y( 0.5 )
			set_background( create {Q_GL_COLOR}.make_gray )
		end
		
feature -- interface
	draw (open_gl: Q_GL_DRAWABLE) is
		local
			ascent_, descent_ : DOUBLE
			string_ : STRING
		do			
			draw_background( open_gl )

			ascent_ := font.max_ascent( font_size )
			descent_ := font.max_descent( font_size )

			if ascent_ + descent_ > height then
				font.draw_string ("_", 0, height/2, font_size, open_gl )
			else
				string_ := font.compact ( text, font_size, width )
	
				font.draw_string( string_, 
					alignement_x * ( width - font.string_width( string_, font_size ) ),
					(  alignement_y)*(height - descent_) +
					(1-alignement_y)*( ascent_ ), font_size, open_gl )
			end
		end
	
	draw_background( open_gl : Q_GL_DRAWABLE ) is
		do
			if background /= void then
				background.set( open_gl )

				open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_quads )
				open_gl.gl.gl_vertex2d( 0, 0 )
				open_gl.gl.gl_vertex2d( width, 0 )
				open_gl.gl.gl_vertex2d( width, height )
				open_gl.gl.gl_vertex2d( 0, height )
				open_gl.gl.gl_end		
			end
		end
		
	
feature -- values
	text : STRING
		-- String to display
		
	font : Q_HUD_FONT
		-- Font to display string
		
	font_size : DOUBLE
		-- Size of the font
		
	background : Q_GL_COLOR
		
	alignement_x, alignement_y : DOUBLE

	set_text( text_ : STRING) is
			-- Sets the text
		do
			text := text_
		end
		
	set_font( font_ : Q_HUD_FONT ) is
		require
			font_not_void : font_ /= void
		do
			font := font_
		end
	
	set_font_size( font_size_ : DOUBLE ) is
		require
			size_positiv : font_size_ > 0
		do
			font_size := font_size_
		end
		
	set_alignement_x( alignement_ : DOUBLE ) is
			-- Sets the horizontal alignement. A value of 0 means, that the text
			-- is drawn at the left side, a value of 1 forces the text to the right side
		do
			alignement_x := alignement_
		end
		
	set_alignement_y( alignement_ : DOUBLE ) is
			-- Sets the vertical alignement. A value of 0 puts the text
			-- at the top of the label, a value of 1 puts the text at
			-- the bottom
		do
			alignement_y := alignement_
		end
		
	set_background( background_ : Q_GL_COLOR ) is
			-- Sets the background-color of this label. A value of
			-- void means, that no background should be painted
		do
			background := background_
		end
		
		
end -- class Q_HUD_LABEL
