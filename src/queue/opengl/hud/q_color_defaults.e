indexing
	description: "A map of default color-values"
	author: "Benjamin Sigg"

class
	Q_COLOR_DEFAULTS
	
creation
	make
	
feature{NONE} -- creation
	make( file_ : STRING ) is
		local
			text_file_  : PLAIN_TEXT_FILE 
		do
			create text_file_.make_open_read( file_ )
			create defaults.make
			defaults.load_ini_file( text_file_ )
			text_file_.close
		end
	
feature{NONE} -- values
	defaults : Q_INI_FILE_READER

feature -- access
	color_of( component_, key_ : STRING ) : Q_GL_COLOR is
		local
			color_ : STRING
			scanner_ : Q_TEXT_SCANNER
			red_, green_, blue_, alpha_ : DOUBLE
		do
			color_ := defaults.value( component_, key_ )
			create scanner_.make_from_string_with_delimiters( color_, "-%T" )
			
			scanner_.read_token
			red_ := scanner_.last_string.to_double

			scanner_.read_token
			green_ := scanner_.last_string.to_double
			
			scanner_.read_token
			blue_ := scanner_.last_string.to_double
			
			scanner_.read_token
			alpha_ := scanner_.last_string.to_double
			
			create result.make_rgba( red_, green_, blue_, alpha_ )
		end
		
	blend( component_ : STRING ) : BOOLEAN is
		local
			string_ : STRING
		do
			string_ := defaults.value( component_, "blend" )
			if string_ = void then
				result := false
			else
				result := string_.to_boolean
			end
		end
		

end -- class Q_COLOR_DEFAULTS
