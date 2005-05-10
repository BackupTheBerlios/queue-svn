indexing
	description: "Basic class for components using a text."
	author: "Benjamin Sigg"

deferred class
	Q_HUD_TEXTED

inherit
	Q_HUD_COMPONENT

feature -- drawing
	draw_foreground( open_gl: Q_GL_DRAWABLE ) is
		local
			ascent_, descent_ : DOUBLE
			string_ : STRING
		do			
			ascent_ := font.max_ascent( font_size )
			descent_ := font.max_descent( font_size )

			if ascent_ + descent_ > height then
				draw_text( "_", 0, height/2, ascent_, descent_, open_gl )
			else
				string_ := font.compact ( text, font_size, width )
	
				draw_text( string_,
					alignement_x * ( width - font.string_width( string_, font_size ) ),
					(  alignement_y)*(height - descent_) +
					(1-alignement_y)*( ascent_ ), ascent_, descent_, open_gl )
			end
		end

	draw_text( text_ : STRING; x_, base_, ascent_, descent_ : DOUBLE; open_gl : Q_GL_DRAWABLE ) is
			-- Draws the text of this drawable. ascent_ and descent_ are the values,
			-- font.max_ascent/max_descent would give back
		do
			font.draw_string(text_, x_, base_, font_size, open_gl )
		end
		

feature -- values
	text : STRING
		-- String to display
		
	font : Q_HUD_FONT
		-- Font to display string
		
	font_size : DOUBLE
		-- Size of the font
		
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
end -- class Q_HUD_TEXTED
