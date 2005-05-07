indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HUD_LABEL

inherit
	Q_HUD_COMPONENT
	
feature -- interface
	draw (open_gl: Q_GL_DRAWABLE) is
		do
			font.draw_string( text, x + (width - font.string_width ( text, font_size ))/2, height/2, font_size, open_gl )
		end
	
feature -- values
	text : STRING
		-- String to display
		
	font : Q_HUD_FONT
		-- Font to display string
		
	font_size : DOUBLE
		-- Size of the font

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
		

end -- class Q_HUD_LABEL
