indexing
	description: "A object loader for the wavefront obj 3d file format."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

class	
	Q_GL_3D_OBJ_LOADER

inherit 
	Q_GL_3D_LOADER
	
	Q_GL_3D_GEOMOBJ

create
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
			tokenizer_: Q_TEXT_SCANNER
		do		
			create vectors.make (0,2)
			create normals.make (0,2)
			create texture_coordinates.make(0,1)
			create faces.make (0,0)

			create tokenizer_.make_from_string_with_delimiters ("", " %T")

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
					
					tokenizer_.set_source_string (obj_file_.last_string)
					
					-- set the iterator
					tokenizer_.read_token
					
					if tokenizer_.last_string.is_equal ("#") then
						-- ignore this line, it's a comment
					elseif tokenizer_.last_string.is_equal ("v") then
						-- read a vector
						tokenizer_.read_token
						vectors.force (read_vector (tokenizer_), vector_count)
						vector_count := vector_count + 1
						has_vectors := TRUE
					elseif tokenizer_.last_string.is_equal ("vn") then
						-- read a vector
						tokenizer_.read_token
						normals.force (read_vector (tokenizer_), normal_count)
						normal_count := normal_count + 1
						has_normals := TRUE
					elseif tokenizer_.last_string.is_equal ("vt") then
						-- read a vector
						tokenizer_.read_token
						vectors.force (read_vector (tokenizer_), texture_coordinate_count)
						texture_coordinate_count := texture_coordinate_count + 1
						has_texture_cooridnates := TRUE
					elseif tokenizer_.last_string.is_equal ("f")  then
						-- face data
						tokenizer_.read_token
						faces.force (read_face (tokenizer_), face_count)
						face_count := face_count + 1
					else
						-- ignore this line, since I can't use it
					end
				end
			end
		end
		
	create_flat_model : Q_GL_GROUP[Q_GL_FLAT_MODEL] is
			-- Create a flat object.
		local
			index_, inner_index_:INTEGER
			curr_face_:TUPLE[ARRAY[INTEGER],ARRAY[INTEGER], ARRAY[INTEGER]]
			vertex_:Q_GL_VERTEX
			
			curr_array_:ARRAY[INTEGER]
			model_ : Q_GL_FLAT_MODEL
		do
			create result.make
			create model_.make(faces.count*3)
			
			from
				index_ := 0
			until
				index_ >= faces.count
			loop
				curr_face_ := faces @ (index_)
				
				-- process this face
				from inner_index_ := 0 until inner_index_ >= 3
				loop
					create vertex_
					
					if has_vectors then
						curr_array_ ?= curr_face_ @ (1)
						
						vertex_.set_position (
									vectors @ (curr_array_ @ (inner_index_) - 1) @ (0),
									vectors @ (curr_array_ @ (inner_index_) - 1) @ (1),
									vectors @ (curr_array_ @ (inner_index_) - 1) @ (2)
											 )
					end
					
					if has_texture_cooridnates then
						curr_array_ ?= curr_face_ @ (2)
						
						vertex_.set_texture_coordinates (
										texture_coordinates @ (curr_array_ @ (inner_index_) - 1) @ (0),
										texture_coordinates @ (curr_array_ @ (inner_index_) - 1) @ (1)
											 			)
					end
					
					if has_normals then
						curr_array_ ?= curr_face_ @ (3)
						
						vertex_.set_normal (
									normals @ (curr_array_ @ (inner_index_) - 1) @ (0),
									normals @ (curr_array_ @ (inner_index_) - 1) @ (1),
									normals @ (curr_array_ @ (inner_index_) - 1) @ (2)
										   )
					end
					
					model_.vertices.force (vertex_, 3*index_+inner_index_)
					inner_index_ := inner_index_ + 1
				end
				index_ := index_ + 1
			end
			
			result.extend (model_)
		end
	
	create_index_model : Q_GL_INDEX_MODEL is
		do
		end
		
feature {NONE} -- implementation
	read_vector (input: Q_TEXT_SCANNER): ARRAY[DOUBLE] is
			-- Read the vertex data from the current position
		local
			index_: INTEGER
		do
			create result.make(0,2)
			
			from
				index_ := 0
			until
				input.last_string.is_equal ("")
			loop
				result.force (input.last_string.to_double, index_)	
				input.read_token
				index_ := index_ + 1
			end
			
		end
		
	read_face (input: Q_TEXT_SCANNER): TUPLE[ARRAY[INTEGER],ARRAY[INTEGER], ARRAY[INTEGER]] is
			-- Read the face data from the current position
		local
			tokenizer_: Q_TEXT_SCANNER
			vectors_: ARRAY[INTEGER]
			vectors_index_: INTEGER
			normals_: ARRAY[INTEGER]
			normals_index_:INTEGER
			tex_coords_: ARRAY[INTEGER]
			tex_coords_index:INTEGER
		do
			create result
			
			create tokenizer_.make_from_string_with_delimiters ("", "/")
			
			create vectors_.make (0,2)
			create normals_.make (0,2)
			create tex_coords_.make (0,1)
			
			from
				
			until
				input.last_string.is_equal ("")
			loop
				tokenizer_.set_source_string (input.last_string)
				
				tokenizer_.read_token
				if not tokenizer_.last_string.is_equal ("") and has_vectors then					
					vectors_.force (tokenizer_.last_string.to_integer, vectors_index_)
					vectors_index_ := vectors_index_ + 1
					tokenizer_.read_token
				end
				
				if not tokenizer_.last_string.is_equal ("") and has_texture_cooridnates then					
					tex_coords_.force (tokenizer_.last_string.to_integer, tex_coords_index)
					tex_coords_index := tex_coords_index + 1
					tokenizer_.read_token
				end
				
				if not tokenizer_.last_string.is_equal ("") and has_normals then					
					normals_.force (tokenizer_.last_string.to_integer, normals_index_)
					normals_index_ := normals_index_ + 1
					tokenizer_.read_token
				end
				
				input.read_token
			end
			
			result.put (vectors_, 1)
			result.put (tex_coords_, 2)
			result.put (normals_, 3)
		end
end
