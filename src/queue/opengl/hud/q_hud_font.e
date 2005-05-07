indexing
	description: "A list of letters to be drawn on the screen"
	author: "Benjamin Sigg"
	revision: "1.0"

deferred class
	Q_HUD_FONT

feature -- drawing
	draw_string( text_ : STRING; x_, base_, size_ : DOUBLE; open_gl : Q_GL_DRAWABLE ) is
		require
			valid_string( text_ )
		local
			count_, index_ : INTEGER
			x__ : DOUBLE
			c_ : CHARACTER
		do
			from
				x__ := x_
				index_ := 1
				count_ := text_.count
			until
				index_ > count_
			loop
				c_ := text_.item( index_ )
				
				draw_letter( c_, x__, base_, size_, open_gl )
				x__ := x__ + width_of_letter( c_, size_ )
				
				index_ := index_ + 1
			end
		end
		

	draw_letter( letter_ : CHARACTER; x_, base_, size_ : DOUBLE; open_gl : Q_GL_DRAWABLE;  ) is
			-- Draws a letter to the screen.
			-- letter_ : The letter to be drawn
			-- x_ : Left start of the letter (first Pixel of the Letter will be on this mark)
			-- base_ : Baseline for the letter. For letters like a or b, this will no pixel
			--		   will be painted under this line, for letters like g or q, there are
			--		   pixels under the base
			-- size_ : The relative size of the Text.
			-- open_gl : Drawable to paint with. The glVertex2d-methodes will be used,
			-- to draw the letter, expecting, that the point 0/0 ist top left
			
		require
			known_letter( letter_ )				
		deferred
		
		end		
		
feature -- font information
	string_width( string_ : STRING; size_ : DOUBLE ) : DOUBLE is
			-- Calculates the length of a string
		require
			string_not_void : string_ /= void
			valid_string( string_ )
		local
			index_, count_ : INTEGER
		do
			from
				index_ := 1
				count_ := string_.count
				result := 0
			until
				index_ > count_
			loop
				result := result + width_of_letter( string_.item( index_ ), size_ )
				index_ := index_ + 1
			end
		end
		

	width_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Calculates the width of a letter, by a given size
		require
			known_letter( letter_ )
		deferred
		end
	
	height_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the height of a letter. For a letter like M or Q, this should be the same as size_,
			-- letters like a or c can be much smaller, and letters like f or J can be greater
		require
			known_letter( letter_ )
		deferred
		end
	
	base_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the baseline of a character. The baseline is the distanc between top and the pixel
			-- on the "0"-line 
		require
			known_letter( letter_ )
		deferred
		end
		
	
	base_top_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the size a letter shows over the baseline. For a letter like m, this
			-- will be equal to height_of_letter
		require
			known_letter( letter_ )
		do
			result := base_of_letter( letter_, size_ )
		end

	base_bottom_of_letter( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the size a letter shows under the baseline. For a letter like m, this
			-- will be equal to 0, a letter like g will have a positive number
		require
			known_letter( letter_ )
		do
			result := height_of_letter( letter_, size_ ) - base_of_letter( letter_, size_ )
		end		

feature -- validation
	valid_string( text_ : STRING ) : BOOLEAN is
			-- tests, if all characters in the given text can be displayed by this font
		require
			text_not_void : text_ /= void
		local
			count_, index_ : INTEGER
		do
			from
				count_ := text_.count
				index_ := 1
				result := true
			until
				index_ = count_
			loop
				result := result and then known_letter( text_.item( index_ ) )
				index_ := index_ + 1
			end
		end
		
	
	known_letter( letter_ : CHARACTER ) : BOOLEAN is
			-- searches for the letter, true, if the letter can be drawn, false otherwise			
		deferred
		end

end -- class Q_HUD_FONT
