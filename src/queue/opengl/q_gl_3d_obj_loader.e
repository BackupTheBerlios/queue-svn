indexing
	description: "A object loader for the wavefront obj 3d file format."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

class	
	Q_GL_3D_OBJ_LOADER

inherit 
	Q_GL_3D_LOADER
		redefine
			load_file
		end

creation
	make

feature -- Initialization

	make is
		do
			
		end
		
feature  -- Commands

	load_file (a_filename: STRING) is
			-- Load an object from 'a_filename'
		local
			obj_file_: PLAIN_TEXT_FILE
			tokenizer_: STRING_TOKENIZER
		do		
			create vectors.make (0,2)
			create normals.make (0,2)
			create texture_coordinates.make(0,1)
			create faces.make (0,0)

			create tokenizer_.make ("", " ")

			create obj_file_.make_open_read (a_filename)
			-- read line for line
			from
				vector_count := 0
				normal_count := 0
				texture_coordinate_count := 0
				face_count := 0
			until
				obj_file_.after
			loop
				-- read first character and decide what to do
				obj_file_.read_line
				
				if not obj_file_.last_string.is_empty then
					
					tokenizer_.make (obj_file_.last_string, " ")
					
					-- set the iterator
					tokenizer_.start
					
					if tokenizer_.item.is_equal ("#") then
						-- ignore this line, it's a comment
					elseif tokenizer_.item.is_equal ("v") then
						-- read a vector
						tokenizer_.forth
						vectors.force (read_vector (tokenizer_), vector_count)
						vector_count := vector_count + 1
						has_vectors := TRUE
					elseif tokenizer_.item.is_equal ("vn") then
						-- read a vector
						tokenizer_.forth
						normals.force (read_vector (tokenizer_), normal_count)
						normal_count := normal_count + 1
						has_normals := TRUE
					elseif tokenizer_.item.is_equal ("vt") then
						-- read a vector
						tokenizer_.forth
						vectors.force (read_vector (tokenizer_), texture_coordinate_count)
						texture_coordinate_count := texture_coordinate_count + 1
						has_texture_cooridnates := TRUE
					elseif tokenizer_.item.is_equal ("f")  then
						-- face data
						tokenizer_.forth
						faces.force (read_face (tokenizer_), face_count)
						face_count := face_count + 1
					else
						-- ignore this line, since I can't use it
					end
				end
			end
		end
		
feature {NONE} -- implementation
	read_vector (input: STRING_TOKENIZER): ARRAY[DOUBLE] is
			-- Read the vertex data from the current position
		local
			index_: INTEGER
		do
			create result.make(0,2)
			
			from
				index_ := 0
			until
				input.off
			loop
				result.force (input.item.to_double, index_)	
				input.forth
			end
			
		end
		
	read_face (input: STRING_TOKENIZER): TUPLE[ARRAY[INTEGER],ARRAY[INTEGER], ARRAY[INTEGER]] is
			-- Read the face data from the current position
		local
			tokenizer_: STRING_TOKENIZER
			vectors_: ARRAY[INTEGER]
			vectors_index_: INTEGER
			normals_: ARRAY[INTEGER]
			normals_index_:INTEGER
			tex_coords_: ARRAY[INTEGER]
			tex_coords_index:INTEGER
			
			index_: INTEGER
		do
			create result
			
			create tokenizer_.make ("", "/")
			
			create vectors_.make (0,2)
			create normals_.make (0,2)
			create tex_coords_.make (0,1)
			
			from
				index_ := 0
			until
				input.off
			loop
				tokenizer_.make(input.item, "/")
				
				tokenizer_.start
				if not tokenizer_.off and has_vectors then					
					vectors_.force (tokenizer_.item.to_integer, vectors_index_)
					vectors_index_ := vectors_index_ + 1
					tokenizer_.forth
				end
				
				if not tokenizer_.off and has_texture_cooridnates then					
					tex_coords_.force (tokenizer_.item.to_integer, tex_coords_index)
					tex_coords_index := tex_coords_index + 1
				end
				
				if not tokenizer_.off and has_normals then					
					normals_.force (tokenizer_.item.to_integer, normals_index_)
					normals_index_ := normals_index_ + 1
					tokenizer_.forth
				end
				
				input.forth
			end
			
			result.put (vectors_, 1)
			result.put (tex_coords_, 2)
			result.put (normals_, 3)
		end

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
			-- Faces, described with indizes to the vertices,
			-- normals and texture coordinates
end
