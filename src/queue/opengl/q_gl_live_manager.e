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
	description: "The Live-Manager has a set of livables. If a livable does not tell, that it is alive, the manager will call a death-feature"
	author: "Benjamin Sigg"

class
	Q_GL_LIVE_MANAGER

creation
	make

feature{NONE} -- creation
	make is
		do
			create livables.make( 10 )
		end
		

feature -- managing
	alive( livable_ : Q_GL_LIVABLE ) is
		require
			livable_not_void : livable_ /= void
		do
			livables.force( true, livable_ )	
		end
		
	grow is
			-- Sets the alive-state of all known livables to false.
			-- If they do not call the alive-feature, they will be killed
			-- by the next kill-call
		do
			from
				livables.start
			until
				livables.after
			loop
				livables.replace( false, livables.key_for_iteration )
				livables.forth
			end
		end
		
	
	kill( open_gl : Q_GL_DRAWABLE ) is
			-- kills all livables witch did not call alive, since the last grow-call
		local
			livable_ : Q_GL_LIVABLE
		do		
			from
				livables.start
			until
				livables.after
			loop
				if livables.item_for_iteration then
					livables.forth
				else
					livable_ := livables.key_for_iteration
					livables.remove( livable_ )
					livable_.death( open_gl )
				end
			end
		end
		

feature {NONE} -- internals
	livables : HASH_TABLE[ BOOLEAN, Q_GL_LIVABLE ]

end -- class Q_GL_LIVE_MANAGER
