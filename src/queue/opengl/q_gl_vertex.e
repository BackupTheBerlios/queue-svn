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
	description: "A class capsulating a complete vertex."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

class Q_GL_VERTEX
   
feature -- setter
	set_position (new_x, new_y, new_z:DOUBLE) is
			-- set the position
		do
			x := new_x
			y := new_y
			z := new_z
		end
		
	set_normal (new_nx, new_ny, new_nz:DOUBLE) is
			-- set the position
		do
			nx := new_nx
			ny := new_ny
			nz := new_nz
		end
		
	set_texture_coordinates (new_tu, new_tv:DOUBLE) is
			-- set the position
		do
			tu := new_tu
			tv := new_tv
		end
		
   
feature -- access
	x, y, z: DOUBLE
		-- Coordinates

	tu, tv: DOUBLE
		-- Texture coordinates
	
	nx, ny, nz: DOUBLE
		-- Normal
end
