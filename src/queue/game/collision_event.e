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
	description: "Objects that represent a collision or fall between two objects (bank,ball,hole) this is used in a list for collision tracking"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_COLLISION_EVENT

create
	make
	
feature -- Interface

	aggressor: Q_BALL -- the object that triggers the event, must be a ball
	defendent: Q_OBJECT -- the object that is hit, can be a ball, bank or hole
	
	make (aggressor_:Q_BALL; defendent_:Q_OBJECT) is
			-- creates a collision_event
		do
			aggressor := aggressor_
			defendent := defendent_
		end
		

feature {NONE} -- Implementation

invariant
	aggressor /= Void
	defendent /= Void

end -- class COLLISION_EVENT
