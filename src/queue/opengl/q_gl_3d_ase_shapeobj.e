indexing
	description: "Represents a shape object from a ase file."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/21 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_3D_ASE_SHAPEOBJ
	
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
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*NODE_NAME") then
					read_name_from_string (file_.last_string)
				elseif scanner.last_string.is_equal ("*NODE_TM") then
					read_subclause (file_)
				elseif scanner.last_string.is_equal ("*SHAPE_LINECOUNT") then
					scanner.read_token
					number_of_shapes := scanner.last_string.to_integer
				elseif scanner.last_string.is_equal ("*SHAPE_LINE") then
					read_shape_line (file_)
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
		
	read_shape_line(file_: PLAIN_TEXT_FILE) is
			-- reads a subclause and discards it
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
			curr_knot_ : Q_VECTOR_3D
		do			
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				if scanner.last_string.is_equal ("*SHAPE_VERTEXCOUNT") then
					scanner.read_token
					create knots.make (0, scanner.last_string.to_integer - 1)
					create knot_types.make (0, scanner.last_string.to_integer - 1)
					
					file_.read_line
				elseif scanner.last_string.is_equal ("*SHAPE_VERTEX_KNOT") then
					knot_types.put (True, index_)
					
					create curr_knot_
					
					scanner.read_token
					index_ := scanner.last_string.to_integer
					
					scanner.read_token
					curr_knot_.set_x (scanner.last_string.to_double)
					
					scanner.read_token
					curr_knot_.set_z (scanner.last_string.to_double)
					
					scanner.read_token
					curr_knot_.set_y (scanner.last_string.to_double)
					
					knots.force (curr_knot_, index_)
					
					index_ := index_ + 1
					
					file_.read_line
				elseif scanner.last_string.is_equal ("*SHAPE_VERTEX_INTERP") then
					knot_types.put (False, index_)
					
					create curr_knot_
					
					scanner.read_token
					index_ := scanner.last_string.to_integer
					
					scanner.read_token
					curr_knot_.set_x (scanner.last_string.to_double)
					
					scanner.read_token
					curr_knot_.set_z (scanner.last_string.to_double)
					
					scanner.read_token
					curr_knot_.set_y (scanner.last_string.to_double)
					
					knots.force (curr_knot_, index_)
					
					index_ := index_ + 1
					
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

feature -- Primitive creation
	create_primitve : Q_GL_OBJECT is
			-- Create a primitive
		local
			line : Q_GL_LINE
			multi_line : Q_GL_SEGMENTED_LINE
		do
			if knots.count = 1 then
			elseif knots.count = 2 then
				create line.make_position_material (knots.item (0), knots.item (1), create {Q_GL_MATERIAL}.make_empty )
				line.material.set_diffuse (create {Q_GL_COLOR}.make_white)
				result := line
			elseif knots.count > 2 then
				create multi_line.make_from_array_with_material (knots, create {Q_GL_MATERIAL}.make_empty )
				multi_line.material.set_diffuse (create {Q_GL_COLOR}.make_white)
				result := multi_line
			end
		end
		

feature -- Access
	name : STRING
	
	number_of_shapes : INTEGER
	
	knots : ARRAY[Q_VECTOR_3D]
	
	knot_types : ARRAY[BOOLEAN]
		-- Entries are 'True' is the knot is a knot,
		-- 'False' is it is a interpolated point
	
end -- class Q_GL_3D_ASE_SHAPEOBJ
