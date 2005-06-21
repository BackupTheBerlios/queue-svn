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
	description: "Basic class for components using a text."
	author: "Benjamin Sigg"

deferred class
	Q_HUD_TEXTED

inherit
	Q_HUD_COMPONENT
	redefine
		make
	end

feature {Q_HUD_COMPONENT} -- creation
		make is
			-- Sets the default settings for the font
		do
			precursor
			set_font( font_defaults.font( "default" ))
			set_font_size( 0.05 )
			set_text( "" )
		end

feature -- drawing
	draw_foreground( open_gl: Q_GL_DRAWABLE ) is
		local
			ascent_, descent_ : DOUBLE
			string_ : STRING
			x_, y_, width_, height_ : DOUBLE
		do			
			ascent_ := font.max_ascent( font_size )
			descent_ := font.max_descent( font_size )

			if insets = void then
				x_ := 0
				y_ := 0
				width_ := width
				height_ := height
			else
				x_ := insets.left * width
				y_ := insets.top * height
				width_ := (1 - insets.left - insets.right) * width
				height_ := (1 - insets.top - insets.bottom) * height
			end

			if ascent_ + descent_ > height_ then
				draw_text( "_", 0, y_ + height_/2, ascent_, descent_, open_gl )
			else
				string_ := font.compact ( text, font_size, width_ )
		
				draw_text( string_,
					x_ + alignement_x *( width_ - font.string_width( string_, font_size ) ),
					y_ + alignement_y *( height_ - descent_) +
					(1-alignement_y)*( ascent_ ), ascent_, descent_, open_gl )
			end
		end

	draw_text( text_ : STRING; x_, base_, ascent_, descent_ : DOUBLE; open_gl : Q_GL_DRAWABLE ) is
			-- Draws the text of this drawable. ascent_ and descent_ are the values,
			-- font.max_ascent/max_descent would give back
		do
			font.draw_string(text_, x_, base_, font_size, open_gl )
			if focused then
				draw_focus_of_text( text_, x_, base_, ascent_, descent_, open_gl )
			end
		end
		
	draw_focus_of_text( text_ : STRING; x_, base_, ascent_, descent_ : DOUBLE; open_gl : Q_GL_DRAWABLE ) is
		local
			bx_, by_, bw_, bh_ : DOUBLE
		do
			foreground.set( open_gl )
		
			bx_ := x_ - font_size / 10
			by_ := base_ - ascent_ - font_size / 10
			bw_ := font_size / 5 + font.string_width( text_, font_size )
			bh_ := font_size / 5 + ascent_ + descent_
			
			if bx_ < 0 then bx_ := 0 end
			if by_ < 0 then by_ := 0 end
				
			if bw_ > width then
				bw_ := width
				bx_ := 0
			end
				
			if bh_ > height then
				bh_ := height
				by_ := 0
			end
				
			open_gl.gl.gl_begin( open_gl.gl_constants.esdl_gl_line_loop )
				
			open_gl.gl.gl_vertex2d( bx_, by_ )
			open_gl.gl.gl_vertex2d( bx_, by_ + bh_ )
			open_gl.gl.gl_vertex2d( bx_ + bw_, by_ + bh_ )
			open_gl.gl.gl_vertex2d( bx_ + bw_, by_ )
			
			open_gl.gl.gl_end
		end
		
	visible : BOOLEAN is
		do
			result := true
		end
		
	
feature -- values
	text : STRING
		-- String to display
		
	font : Q_HUD_FONT
		-- Font to display string
		
	font_size : DOUBLE
		-- Size of the font
		
	alignement_x, alignement_y : DOUBLE

	insets : Q_HUD_INSETS

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
		
	set_insets( insets_ : Q_HUD_INSETS ) is
			-- Sets the insets. No text will be drawen outside this insts.
			-- The insets are relativ to the size of this component
			-- A value of void means, that no insets are used
		do
			insets := insets_
		end
	
end -- class Q_HUD_TEXTED
