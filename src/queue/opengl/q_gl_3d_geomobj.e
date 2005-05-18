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
