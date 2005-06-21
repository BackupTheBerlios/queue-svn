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
	description: "Object that can die. On every call of draw, the livable must call the alive-feature of the live-manager. If the livable does not call the feature, its death-feature will be called, after all other Q_GL_OBJECTS are drawed"
	author: "Benjamin Sigg"

deferred class
	Q_GL_LIVABLE

inherit
	Q_GL_OBJECT
	HASHABLE

feature -- death
	death( open_gl : Q_GL_DRAWABLE ) is
			-- Is called, when the LIVABLE has not called the alive-feature of the live-manager
		require
			open_gl_not_void : open_gl /= void
		deferred
		end
		

end -- class Q_GL_LIVABLE
