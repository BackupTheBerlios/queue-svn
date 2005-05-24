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
	
end -- class Q_GL_3D_ASE_SHAPEOBJ
