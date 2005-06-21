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
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_GL_3D_GEOMOBJ

feature -- Access
	vector_count: INTEGER
			-- number of vertices
	
	normal_count: INTEGER
			-- number of normals
	
	texture_coordinate_count: INTEGER
			-- number texture coordinates
			
	has_vectors: BOOLEAN
		-- indicate if the file has vectors
	
	has_normals: BOOLEAN
		-- indicate if the file has normals
		
	has_texture_cooridnates: BOOLEAN
		-- indicate if the file has texture_coordinates
	
	face_count: INTEGER
			-- number of faces

	vectors: ARRAY[ARRAY[DOUBLE]]
			-- Array with all vertices
			
	normals: ARRAY[ARRAY[DOUBLE]]
			-- Array with all normals
			
	texture_coordinates: ARRAY[ARRAY[DOUBLE]]
			-- Array with all texture coordinates

	faces: ARRAY[
				 TUPLE[
					   ARRAY[INTEGER],
					   ARRAY[INTEGER],
					   ARRAY[INTEGER]
					  ]
				 ]
			-- Faces, described by indizes to the vertices,
			-- texture coordinates and normals
end -- class Q_GL_3D_GEOMOBJ
