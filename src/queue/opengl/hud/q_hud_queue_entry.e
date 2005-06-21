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
	description: "Helperclass"
	author: "Benjamin Sigg"

class
	Q_HUD_QUEUE_ENTRY

feature{Q_HUD_QUEUE}
	component : Q_HUD_COMPONENT
	
	set_component( component_ : Q_HUD_COMPONENT ) is
		do
			component := component_
		end
		
	matrix : Q_MATRIX_4X4
	
	set_matrix( matrix_ : Q_MATRIX_4X4 ) is
		do
			matrix := matrix_
		end
		
	vectorized_plane : Q_VECTORIZED_PLANE
	
	set_vectorized_plane( plane_ : Q_VECTORIZED_PLANE ) is
		do
			vectorized_plane := plane_
		end
		

end -- class Q_HUD_QUEUE_ENTRY
