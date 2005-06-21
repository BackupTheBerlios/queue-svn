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
	description: "The result of a search in a q_hud_component_queue"
	author: "Benjamin Sigg"

class
	Q_HUD_QUEUE_SEARCH_RESULT

creation
	make, make_empty

feature {NONE}
	make_empty is
		do
			
		end
		
	make( index_ : INTEGER; component_ : Q_HUD_COMPONENT; position_ : Q_VECTOR_2D ) is
		do
			set_index( index_ )
			set_component( component_ )
			set_position( position_ )
		end
		
feature
	component : Q_HUD_COMPONENT
	index : INTEGER
	position : Q_VECTOR_2D
	
	set_component( component_ : Q_HUD_COMPONENT ) is
		do
			component := component_
		end
		
	set_index( index_ : INTEGER ) is
		do
			index := index_
		end
		
	set_position( position_ : Q_VECTOR_2D ) is
		do
			position := position_
		end
		
end -- class Q_HUD_QUEUE_SEARCH_RESULT
