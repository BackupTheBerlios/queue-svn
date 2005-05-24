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
			tok_ : STRING_TOKENIZER
			off_ : BOOLEAN
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				create tok_.make (file_.last_string, " %T")
				
				tok_.start
				
				if tok_.item.is_equal ("*NODE_NAME") then
					read_name_from_string (file_.last_string)
				elseif tok_.item.is_equal ("*NODE_TM") then
					read_subclause (file_)
				elseif tok_.item.is_equal ("*MESH") then
					read_mesh (file_)
				elseif tok_.item.is_equal ("*WIREFRAME_COLOR") then
					tok_.forth
					create color.make
					color.set_red (tok_.item.to_double)
					tok_.forth
					color.set_green (tok_.item.to_double)
					tok_.forth
					color.set_blue (tok_.item.to_double)
				else
					if tok_.i_th (tok_.count).is_equal ("{") then
						read_subclause (file_)
					end
				end
				
				if tok_.i_th (tok_.count).is_equal ("}") then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
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
			
			-- set the base color
			if color /= void then
				result.set_material (create {Q_GL_MATERIAL}.make_single_colored (color))
			else
				result.set_material (create {Q_GL_MATERIAL}.make_empty)
			end
			
			
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
			tok_ : STRING_TOKENIZER
			off_ : BOOLEAN
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				create tok_.make (file_.last_string, " %T")
				if tok_.i_th (tok_.count).is_equal ("{") then
					read_subclause (file_)
					file_.read_line
				elseif tok_.i_th (tok_.count).is_equal ("}") then
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
			tok_ : STRING_TOKENIZER
			off_ : BOOLEAN
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				create tok_.make (file_.last_string, " %T")
				tok_.start
				
				if tok_.item.is_equal ("*MESH_NUMVERTEX") then
					tok_.forth
					vector_count := tok_.item.to_integer
					file_.read_line
				elseif tok_.item.is_equal ("*MESH_NUMFACES") then
					tok_.forth
					face_count := tok_.item.to_integer
					file_.read_line
				elseif tok_.item.is_equal ("*MESH_VERTEX_LIST") then
					read_vertices (file_)
					file_.read_line
				elseif tok_.item.is_equal ("*MESH_FACE_LIST") then
					read_faces (file_)
					file_.read_line
				elseif tok_.item.is_equal ("*MESH_NORMALS") then
					normal_count := vector_count
					has_normals := True
					read_normals (file_)
					file_.read_line
			elseif tok_.i_th (tok_.count).is_equal ("{") then
					read_subclause (file_)
					file_.read_line
				elseif tok_.i_th (tok_.count).is_equal ("}") then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_vertices (file_: PLAIN_TEXT_FILE) is
			-- Read the vertices of a vertex.
		local
			tok_ : STRING_TOKENIZER
			off_ : BOOLEAN
			
			index_ : INTEGER
			vector_ : ARRAY[DOUBLE]
		do
			create vectors.make (1, vector_count)
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				create tok_.make (file_.last_string, " %T")
				tok_.start
				
				if tok_.item.is_equal ("*MESH_VERTEX") then
					create vector_.make (0, 2)
					
					tok_.forth
					index_ := tok_.item.to_integer
					
					tok_.forth
					vector_.force (tok_.item.to_double, 0)
					tok_.forth
					vector_.force (tok_.item.to_double, 2)
					tok_.forth
					vector_.force (tok_.item.to_double, 1)
					
					vectors.force (vector_, index_)
					
					file_.read_line
				elseif tok_.i_th (tok_.count).is_equal ("}") then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_normals (file_: PLAIN_TEXT_FILE) is
			-- Read the normals of a vertex.
		local
			tok_ : STRING_TOKENIZER
			off_ : BOOLEAN
			
			index_ : INTEGER
			vector_ : ARRAY[DOUBLE]
		do
			create normals.make (1, vector_count)
			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				create tok_.make (file_.last_string, " %T")
				tok_.start
				
				if tok_.item.is_equal ("*MESH_VERTEXNORMAL") then
					create vector_.make (0, 2)
					
					tok_.forth
					index_ := tok_.item.to_integer
					
					tok_.forth
					vector_.force (tok_.item.to_double, 0)
					tok_.forth
					vector_.force (tok_.item.to_double, 2)
					tok_.forth
					vector_.force (tok_.item.to_double, 1)
					
					normals.force (vector_, index_)
					
					file_.read_line
				elseif tok_.i_th (tok_.count).is_equal ("}") then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
	read_faces  (file_: PLAIN_TEXT_FILE) is
			-- Read the vertices of a face.
		local
			tok_ : STRING_TOKENIZER
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
				create tok_.make (file_.last_string, " %T")
				tok_.start
				
				if tok_.item.is_equal ("*MESH_FACE") then
					create face_
					
					-- read the position information
					create pos_.make (0, 2)
					
					has_vectors := True
					
					-- index
					tok_.forth
					index_ := tok_.item.substring (1, tok_.item.count-1).to_integer
					
					-- first
					tok_.forth
					tok_.forth
					pos_.put (tok_.item.to_integer + 1, 0)
					
					-- second
					tok_.forth
					tok_.forth
					pos_.put (tok_.item.to_integer + 1, 1)
					
					-- third
					tok_.forth
					tok_.forth
					pos_.put (tok_.item.to_integer + 1, 2)
					
					-- set it
					face_.put (pos_, 1)
					face_.put (pos_, 3)
					
					-- add to the list
					faces.force (face_, index_)
					
					file_.read_line
				elseif tok_.i_th (tok_.count).is_equal ("}") then
					off_ := True
				else
					file_.read_line
				end
			end
		end
		
feature -- Access
	name : STRING
	
	color : Q_GL_COLOR
	
end -- class Q_GL_3D_ASE_GEOMOBJ
