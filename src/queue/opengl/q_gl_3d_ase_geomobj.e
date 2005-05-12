indexing
	description: "Represents a geometrical object from a ase file."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_3D_ASE_GEOMOBJ

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
					read_subclause (file_)
				elseif tok_.item.is_equal ("*MESH_FACE_LIST") then
					read_subclause (file_)
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
		
		
feature -- Access
	name : STRING
	
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
end -- class Q_GL_3D_ASE_GEOMOBJ
