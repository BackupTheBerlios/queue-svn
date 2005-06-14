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
	values: HASH_TABLE[HASH_TABLE[STRING, STRING], STRING]
		-- The keys and values

feature -- read & get
	load_file( path_ : STRING ) is
		local
			file_ : PLAIN_TEXT_FILE
		do
			create file_.make_open_read( path_ )
			load_ini_file( file_ )
			file_.close
		end
		

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
					
					put( current_section, left, right )
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
		local
			table_ : HASH_TABLE[ STRING, STRING ]
		do
			table_ := values.item( section_name )
			if table_ /= void then
				result := table_.item( value_name )
			end
		end
		
feature -- write & set
	save_file( path_ : STRING ) is
		local
			file_ : PLAIN_TEXT_FILE
		do
			create file_.make_open_write( path_ )
			save_ini_file( file_ )
			file_.close
		end
		

	save_ini_file( file_ : PLAIN_TEXT_FILE ) is
			-- writes all values of this reader into the given textfile
		require
			file_not_void : file_ /= void
			can_write : file_.writable
		local
			table_ : HASH_TABLE[ STRING, STRING ]
		do
			from
				values.start
			until
				values.after
			loop
				file_.put_string( "[" )
				file_.put_string( values.key_for_iteration )
				file_.put_string( "]" )
				file_.put_new_line
				
				from
					table_ := values.item_for_iteration
					table_.start
				until
					table_.after
				loop
					file_.put_string( "%T" )
					file_.put_string( table_.key_for_iteration )
					file_.put_string( " = " )
					file_.put_string( table_.item_for_iteration )
					file_.put_new_line
					table_.forth
				end
				
				values.forth
			end
		end
		

	put( section_, key_, value_ : STRING ) is
		local
			table_ : HASH_TABLE[ STRING, STRING ]
		do
			table_ := values.item( section_ )
			if table_ = void then
				create table_.make( 20 )
				values.put( table_, section_ )
			end
			table_.force( value_, key_ )
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
