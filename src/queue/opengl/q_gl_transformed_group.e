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
	description: "A group witch has a Q_GL_TRANSFORM to change temporarly some settings"
	author: "Benjamin Sigg"

class
	Q_GL_TRANSFORMED_GROUP[Q -> Q_GL_OBJECT]

inherit
	Q_GL_GROUP[Q]
	redefine
		draw
	end


creation
	make

feature -- all
	transform : Q_GL_TRANSFORM
	
	set_transform( transform_ : Q_GL_TRANSFORM ) is
			-- sets the transformation. This can be void, to use no transformation
		do
			transform := transform_
		end
		
	
feature -- visualisation
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			if
				transform = void
			then
				precursor( open_gl )
			else
				transform.transform( open_gl )
				precursor( open_gl )
				transform.untransform( open_gl )
			end
		end
		

end -- class Q_GL_TRANSFORM_GROUP
