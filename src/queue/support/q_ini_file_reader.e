indexing
	description: "A reader for *.ini style files."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/06/07 $"
	revision: "$Revision: 1.0 $"

class
	Q_INI_FILE_READER
	
create
	make, make_and_read
	
feature {NONE} -- Private Features
	values: HASH_TABLE[STRING, STRING]
		-- The keys and values
	
feature -- Interface
	load_ini_file (ini_file: PLAIN_TEXT_FILE) is
			-- Load the specified file.
		require
			ini_file.is_access_readable
			ini_file.is_readable
		local
			scanner, line_scanner, section_scanner: Q_TEXT_SCANNER
			
			current_section: STRING
			left, right: STRING
		do
			create scanner.make_from_string_with_delimiters ("", " %T")
			create line_scanner.make_from_string_with_delimiters ("", "=")
			create section_scanner.make_from_string_with_delimiters ("", " %T[]")
			
			from
				ini_file.read_line
			until
				ini_file.end_of_file
			loop
				scanner.set_source_string (ini_file.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("") then
					-- continue				
				elseif scanner.last_string.count >= 2 and then scanner.last_string.substring (1, 2).is_equal("--") then
					-- Found a comment. Omit it.
				elseif scanner.last_string.index_of ('[',1) = 1 and then ini_file.last_string.has(']') then
					-- Found a section
					section_scanner.set_source_string (ini_file.last_string)
					section_scanner.read_token
					create current_section.make_from_string (section_scanner.last_string)
				elseif ini_file.last_string.has('=') then
					line_scanner.set_source_string (ini_file.last_string)
					line_scanner.read_token
					create left.make_from_string (line_scanner.last_string)
					
					line_scanner.read_token
					create right.make_from_string(line_scanner.last_string)
					
					trim( left )
					trim( right )
					
					values.put (right, current_section + "." + left)
				end

				ini_file.read_line
			end
		end
		
	value (section_name, value_name: STRING): STRING is
			-- Gets a value from the ini file.
			-- If the value doesn't exist, "" is returned.
		require
			section_name /= void
			value_name /= void
		do
			result := values.item (section_name + "." + value_name)
		end
		
feature{NONE} -- string
	trim( string_ : STRING ) is
		local
			count_ : INTEGER
			index_ : INTEGER
		do
			from
				index_ := 1
			until
				index_ > string_.count or				
				not (string_.item( index_ ) = ' ' or
					string_.item( index_ ) = '%T' or
					string_.item( index_ ) = '%R' or
					string_.item( index_ ) = '%N')
			loop
				count_ := count_ + 1
				index_ := index_ + 1
			end
			
			string_.remove_head( count_ )
			
			from
				index_ := string_.count
				count_ := 0
			until
				index_ < 1 or
				not (string_.item( index_ ) = ' ' or
					string_.item( index_ ) = '%T' or
					string_.item( index_ ) = '%R' or
					string_.item( index_ ) = '%N')
			loop
				count_ := count_ + 1
				index_ := index_ - 1
			end
			
			string_.remove_tail( count_ )
		end
		
	
feature{NONE} -- Initialisation
	make is
			-- Set up the invariant.
		do
			create values.make (10)
		end
		
	make_and_read( path_ : STRING ) is
			-- Creates a reader, and read the file given by the path
		require
			path_ /= void
		local
			file_ : PLAIN_TEXT_FILE
		do
			make
			
			create file_.make_open_read( path_ )
			load_ini_file( file_ )
			file_.close
		end
		
		
invariant
	values /= void

end -- class Q_INI_FILE_READER
