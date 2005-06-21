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
				x__ := x__ + width( c_, size_ )
				
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

feature -- optimization
	compact( string_ : STRING; size_, width__ : DOUBLE ) : STRING is
			-- Cuts off letters from string, so that it fits a length of width_
		require
			string_not_void : string_ /= void
		local
			width_ : DOUBLE
		do
			width_ := width__
			
			if string_width( string_, size_ ) <= width_ then
				-- the string is short enough
				result := string_
			else
				width_ := width_ - string_width( "...", size_ )
				if width_ <= 0 then
					result := ""
				else
					-- divide the string, until its shorter than the width
					result := compact_divide( string_, size_, width_ )
					result.append( "..." )
				end
			end
		end

feature{NONE} -- divide and conquer
	compact_divide( string_ : STRING; size_, width_ : DOUBLE ) : STRING is
		local
			left_, right_ : STRING
			middle_ : INTEGER
			left_width_ : DOUBLE
		do
			if width_ <= 0 or string_.count = 0 then
				result := ""
			else
				middle_ := (string_.count-1) // 2 + 1
				left_ := string_.substring( 1, middle_ )				
				left_width_ := string_width( left_, size_ )
				
				if left_width_ > width_ then
					if left_.count <= 1 then
						result := ""
					else
						result := compact_divide( left_, size_, width_ )
					end
				else
					right_ := string_.substring( middle_+1, string_.count )
					result := left_
					result.append( compact_divide( right_, size_, width_-left_width_) )
				end
			end
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
				result := result + width( string_.item( index_ ), size_ )
				index_ := index_ + 1
			end
		end
		
	letter_list : ARRAY[ CHARACTER ] is
			-- a list of the letters, displayable by this font
		deferred
		ensure
			result_not_void : result /= void
		end

	width( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Calculates the width of a letter, by a given size
		require
			known_letter( letter_ )
		deferred
		end
	
	height( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the height of a letter. For a letter like M or Q, this should be the same as size_,
			-- letters like a or c can be much smaller, and letters like f or J can be greater
		require
			known_letter( letter_ )
		deferred
		end
		
	max_height( size_ : DOUBLE ) : DOUBLE is
		local
			letters_ : ARRAY[ CHARACTER ]
			index_ : INTEGER
		do
			result := 0
			letters_ := letter_list
			
			from
				index_ := letters_.lower
			until
				index_ > letters_.upper
			loop
				result := result.max( height( letters_.item( index_ ), size_ ))
				index_ := index_ + 1
			end
		end
	
	base( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the baseline of a character. The baseline is the distanc between top and the pixel
			-- on the "0"-line 
		require
			known_letter( letter_ )
		deferred
		end
	
	ascent( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the size a letter shows over the baseline. For a letter like m, this
			-- will be equal to height_of_letter
		require
			known_letter( letter_ )
		do
			result := height( letter_, size_ ) - base( letter_, size_ )
		end

	max_ascent( size_ : DOUBLE ) : DOUBLE is
		local
			letters_ : ARRAY[ CHARACTER ]
			index_ : INTEGER
		do
			result := 0
			letters_ := letter_list
			
			from
				index_ := letters_.lower
			until
				index_ > letters_.upper
			loop
				result := result.max( ascent( letters_.item( index_ ), size_ ))
				index_ := index_ + 1
			end
		end

	descent( letter_ : CHARACTER; size_ : DOUBLE ) : DOUBLE is
			-- Gets the size a letter shows under the baseline. For a letter like m, this
			-- will be equal to 0, a letter like g will have a positive number
		require
			known_letter( letter_ )
		do
			result := base( letter_, size_ )
		end		
		
	max_descent( size_ : DOUBLE ) : DOUBLE is
		local
			letters_ : ARRAY[ CHARACTER ]
			index_ : INTEGER
		do
			result := 0
			letters_ := letter_list
			
			from
				index_ := letters_.lower
			until
				index_ > letters_.upper
			loop
				result := result.max( descent( letters_.item( index_ ), size_ ))
				index_ := index_ + 1
			end
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
