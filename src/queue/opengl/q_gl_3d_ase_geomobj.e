indexing
	description: "Represents a geometrical object from a ase file."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_3D_ASE_GEOMOBJ
	
inherit
	Q_GL_3D_GEOMOBJ

create
	make

feature {NONE} -- Initialization

	make (file_: PLAIN_TEXT_FILE) is
			-- Initialize `Current'.
		require
			valid_file: file_ /= void and then file_.readable
		local
			off_ : BOOLEAN
		do
			create scanner.make_from_string_with_delimiters ("", " %T")
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string( file_.last_string )
				scanner.read_token
				
				if scanner.last_string.is_equal ("*NODE_NAME") then
					read_name_from_string (file_.last_string)
				elseif scanner.last_string.is_equal ("*NODE_TM") then
					read_subclause (file_)
				elseif scanner.last_string.is_equal ("*MESH") then
					read_mesh (file_)
				elseif scanner.last_string.is_equal ("*MATERIAL_REF") then
					scanner.read_token
					material_index := scanner.last_string.to_integer
				elseif scanner.last_string.is_equal ("*WIREFRAME_COLOR") then
					scanner.read_token
					create color.make
					color.set_red (scanner.last_string.to_double)
					scanner.read_token
					color.set_green (scanner.last_string.to_double)
					scanner.read_token
					color.set_blue (scanner.last_string.to_double)
				else
					if file_.last_string.has ('{') then
						read_subclause (file_)
					elseif file_.last_string.has ('}') then
						off_ := True
					end
				end
				
				if not off_ then
					file_.read_line
				end
			end
		end
		
		scanner : Q_TEXT_SCANNER
		
feature -- Models
	create_flat_model : Q_GL_FLAT_MODEL is
			-- Create a flat object.
		local
			index_, inner_index_:INTEGER
			curr_face_:TUPLE[ARRAY[INTEGER],ARRAY[INTEGER], ARRAY[INTEGER]]
			vertex_:Q_GL_VERTEX
			
			curr_array_:ARRAY[INTEGER]
		do
			create result.make(faces.count*3)			
			
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
									vectors @ (curr_array_ @ (inner_index_)) @ (0),
									vectors @ (curr_array_ @ (inner_index_)) @ (1),
									vectors @ (curr_array_ @ (inner_index_)) @ (2)
											 )
					end
					
					if has_texture_cooridnates then
						curr_array_ ?= curr_face_ @ (2)
						
						vertex_.set_texture_coordinates (
										texture_coordinates @ (curr_array_ @ (inner_index_)) @ (0),
										texture_coordinates @ (curr_array_ @ (inner_index_)) @ (1)
											 			)
					end
					
					if has_normals then
						curr_array_ ?= curr_face_ @ (3)
						
						vertex_.set_normal (
									normals @ (curr_array_ @ (inner_index_)) @ (0),
									normals @ (curr_array_ @ (inner_index_)) @ (1),
									normals @ (curr_array_ @ (inner_index_)) @ (2)
										   )
					end
					
					result.vertices.force (vertex_, 3*index_+inner_index_)
					inner_index_ := inner_index_ + 1
				end
				
				index_ := index_ + 1
			end
		end
		
feature {NONE} -- Implementation
	read_subclause(file_: PLAIN_TEXT_FILE) is
			-- reads a subclause and discards it
		local
			off_ : BOOLEAN
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				if file_.last_string.has ('{') then
					read_subclause (file_)
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_name_from_string (line_ : STRING) is
			-- Set the name.
		require
			valid_input: line_ /= void
		local
			start_, end_: INTEGER
		do
			start_ := line_.index_of ('"', 1)
			end_ := line_.index_of ('"', start_ + 1)
			
			name := line_.substring (start_ + 1, end_ - 1)
		end
		
	read_mesh (file_: PLAIN_TEXT_FILE) is
			-- Read the mesh out of the file.
		local
			off_ : BOOLEAN
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*MESH_NUMVERTEX") then
					scanner.read_token
					vector_count := scanner.last_string.to_integer
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_NUMFACES") then
					scanner.read_token
					face_count := scanner.last_string.to_integer
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_NUMTVFACES") then
					scanner.read_token
					if scanner.last_string.to_integer = face_count and faces /= void then
						has_texture_cooridnates := true
						read_texured_faces (file_)
					else
						read_subclause (file_)
					end
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_NUMTVERTEX") then
					scanner.read_token
					texture_coordinate_count := scanner.last_string.to_integer
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_VERTEX_LIST") then
					read_vertices (file_)
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_TVERTLIST") then
					read_texture_cooridinates (file_)
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_FACE_LIST") then
					read_faces (file_)
					file_.read_line
				elseif scanner.last_string.is_equal ("*MESH_NORMALS") then
					normal_count := vector_count
					has_normals := True
					read_normals (file_)
					file_.read_line
				elseif file_.last_string.has ('{') then
					read_subclause (file_)
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_vertices (file_: PLAIN_TEXT_FILE) is
			-- Read the vertices of a vertex.
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
			vector_ : ARRAY[DOUBLE]
		do
			create vectors.make (0, vector_count - 1)
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*MESH_VERTEX") then
					create vector_.make (0, 2)
					
					scanner.read_token
					index_ := scanner.last_string.to_integer
					
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 0)
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 2)
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 1)
					
					vectors.force (vector_, index_)
					
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_normals (file_: PLAIN_TEXT_FILE) is
			-- Read the normals of a vertex.
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
			vector_ : ARRAY[DOUBLE]
		do
			create normals.make (0, vector_count-1)
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*MESH_VERTEXNORMAL") then
					create vector_.make (0, 2)
					
					scanner.read_token
					index_ := scanner.last_string.to_integer
					
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 0)
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 2)
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 1)
					
					normals.force (vector_, index_)
					
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_texture_cooridinates (file_: PLAIN_TEXT_FILE) is
			-- Read the texture coordinates
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
			vector_ : ARRAY[DOUBLE]
		do
			create texture_coordinates.make (0, texture_coordinate_count - 1)
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*MESH_TVERT") then
					create vector_.make (0, 1)
					
					scanner.read_token
					index_ := scanner.last_string.to_integer
					
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 0)
					scanner.read_token
					vector_.force (scanner.last_string.to_double, 1)
					
					texture_coordinates.force (vector_, index_)
					
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end
		end
	
	read_texured_faces (file_:PLAIN_TEXT_FILE) is
			-- Read the texture coordinates of the faces.
		require
			faces /= void
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
			pos_ : ARRAY[INTEGER]
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				if scanner.last_string.is_equal ("*MESH_TFACE") then
					scanner.read_token
					index_ := scanner.last_string.to_integer
					
					create pos_.make (0, 2)
					
					scanner.read_token
					pos_.put (scanner.last_string.to_integer, 0)
					
					scanner.read_token
					pos_.put (scanner.last_string.to_integer, 1)
					
					scanner.read_token
					pos_.put (scanner.last_string.to_integer, 2)
					
					faces.item (index_).put (pos_, 2)
					
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end	
			
		end
		
		
	read_faces  (file_: PLAIN_TEXT_FILE) is
			-- Read the vertices of a face.
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
			face_ :  TUPLE[ARRAY[INTEGER],ARRAY[INTEGER],ARRAY[INTEGER]]
			pos_ : ARRAY[INTEGER]
		do
			create faces.make (0, face_count - 1)
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*MESH_FACE") then
					create face_
					
					-- read the position information
					create pos_.make (0, 2)
					
					has_vectors := True
					
					-- index
					scanner.read_token
					index_ := scanner.last_string.substring (1, scanner.last_string.count-1).to_integer
					
					-- first
					scanner.read_token
					scanner.read_token
					pos_.put (scanner.last_string.to_integer, 0)
					
					-- second
					scanner.read_token
					scanner.read_token
					pos_.put (scanner.last_string.to_integer, 1)
					
					-- third
					scanner.read_token
					scanner.read_token
					pos_.put (scanner.last_string.to_integer, 2)
					
					-- set it
					face_.put (pos_, 1)
					face_.put (pos_, 3)
					
					-- add to the list
					faces.force (face_, index_)
					
					file_.read_line
				elseif file_.last_string.has ('}') then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
feature -- Access
	name : STRING
	
	color : Q_GL_COLOR
	
	material_index : INTEGER
	
end -- class Q_GL_3D_ASE_GEOMOBJ
