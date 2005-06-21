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
	description: "Object that does only show a rectangle in the space"
	author: "Benjamin Sigg"

class
	Q_HUD_PANEL

inherit
	Q_HUD_COMPONENT
	redefine
		make
	end
	
creation
	make
	
feature{NONE} -- creation
	make is
		do
			precursor
			
			set_enabled( false )
			set_focusable( false )
			set_background( color_defaults.color_of( "panel", "background" ))
			set_blend_background( color_defaults.blend( "panel" ))
		end

feature
	draw_foreground( open_gl : Q_GL_DRAWABLE ) is
		do
			
		end
		
	visible : BOOLEAN is
		do
			result := true
		end
		
	
end -- class Q_HUD_PANEL
