indexing
	description: "A object loader for the 3d Studio Max ase export file format."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class	
	Q_GL_3D_ASE_LOADER

inherit 
	Q_GL_3D_LOADER

create
	make, load_file

feature -- Initialization

	make is
		do
			create geometric_objects.make (0, 1)
			create shape_objects.make (0, 1)
		end
		
feature  -- Commands

	load_file (a_filename: STRING) is
			-- Load an object from 'a_filename'
		local
			ase_file_: PLAIN_TEXT_FILE
			tokenizer_: STRING_TOKENIZER
		do
			create tokenizer_.make ("", " ")

			create ase_file_.make_open_read (a_filename)
			-- read line for line
			from
				ase_file_.read_line
			until
				ase_file_.after
			loop				
				if not ase_file_.last_string.is_empty then
					
					tokenizer_.make (ase_file_.last_string, " %T")
					
					-- set the iterator
					tokenizer_.start
					
					if tokenizer_.item.is_equal ("*COMMENT") then
						tokenizer_.forth
						read_comment (tokenizer_)					
					elseif tokenizer_.item.is_equal ("*3DSMAX_ASCIIEXPORT") then
						tokenizer_.forth
						file_version := tokenizer_.item.to_integer
					elseif tokenizer_.item.is_equal ("*SCENE") then
						-- ignore those for the moment
						read_subclause(ase_file_)
					elseif tokenizer_.item.is_equal ("*MATERIAL_LIST") then
						-- ignore those for the moment
						read_subclause(ase_file_)
					elseif tokenizer_.item.is_equal ("*SHAPEOBJECT") then
						read_shape_object(ase_file_)				
					elseif tokenizer_.item.is_equal ("*GEOMOBJECT") then
						read_geometric_object(ase_file_)				
					else
						-- a not recognized line
						io.put_string (ase_file_.last_string)
						io.put_new_line
					end
				end
				
				ase_file_.read_line
			end
		end
		
	create_flat_model : Q_GL_GROUP[Q_GL_FLAT_MODEL] is
			-- Create a flat object.
		local
			index_ : INTEGER
		do
			create result.make
			
			from
				index_ := geometric_objects.lower
			until
				index_ > geometric_objects.upper
			loop
				result.extend (geometric_objects.item(index_).create_flat_model)
				index_ := index_ + 1
			end
		end
	
	create_index_model : Q_GL_INDEX_MODEL is
		do
		end
		
feature {NONE} -- Implementation
	read_comment(input_: STRING_TOKENIZER) is
			-- reads a comment, and dumps it :)
			-- if anyone really wants them rewrite this.
		do
			from
			until
				input_.off
			loop
				input_.forth
			end
		end
		
		
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
		
	read_geometric_object(file_: PLAIN_TEXT_FILE) is
			-- parses a *GEOMOBJECTS clause
		do
			geometric_objects.force (create {Q_GL_3D_ASE_GEOMOBJ}.make (file_), geometric_object_count)
			
			geometric_object_count := geometric_object_count + 1
		end
		
	read_shape_object(file_: PLAIN_TEXT_FILE) is
			-- parses a *SHAPEOBJECTS clause
		do
			shape_objects.force (create {Q_GL_3D_ASE_SHAPEOBJ}.make (file_), shape_object_count)
			
			shape_object_count := shape_object_count + 1
		end
		
		
feature -- access
	file_version: INTEGER
	
	geometric_objects : ARRAY[Q_GL_3D_ASE_GEOMOBJ]
	
	geometric_object_count : INTEGER
	
	shape_objects : ARRAY[Q_GL_3D_ASE_SHAPEOBJ]
	
	shape_object_count : INTEGER
end
