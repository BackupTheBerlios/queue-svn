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
	description: "Paints a text on the screen, with a background"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_LABEL

inherit
	Q_HUD_TEXTED
	redefine
		make
	end

creation
	make
	
feature {NONE} -- creation
	make is
		do
			precursor
			set_alignement_x( 0.0 )
			set_alignement_y( 0.5 )
			
			set_foreground( color_defaults.color_of( "label", "foreground" ))
			set_background( color_defaults.color_of( "label", "background" ))
			set_blend_background( color_defaults.blend( "label" ) )
			
			set_insets( create {Q_HUD_INSETS}.make( 0.01, 0.05, 0.01, 0.01 ))
			
			set_font( font_defaults.font( "label" ) )
		end
end -- class Q_HUD_LABEL
