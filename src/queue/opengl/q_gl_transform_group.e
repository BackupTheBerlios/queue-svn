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
	description: "A group of various transformations"
	author: "Benjamin Sigg"

class
	Q_GL_TRANSFORM_GROUP[Q -> Q_GL_TRANSFORM]

inherit
	Q_GL_TRANSFORM
	undefine
		copy, is_equal
	end
	ARRAYED_LIST[Q]
	
creation
	make

feature -- transformation
	transform( open_gl : Q_GL_DRAWABLE ) is
		do
			from
				start
			until
				after
			loop
				item.transform( open_gl )
				forth
			end
		end
	
	untransform( open_gl : Q_GL_DRAWABLE ) is
		local
			index_ : INTEGER
		do
			from
				index_ := count
			until
				index_ < 0
			loop
				i_th( index_ ).untransform( open_gl )
				index_ := index_ - 1
			end
		end
		

end -- class Q_GL_TRANSFORM_GROUP
