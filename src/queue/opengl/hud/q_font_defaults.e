indexing
	description: "A list of fonts, to be used by buttons etc."
	author: "Benjamin Sigg"

class
	Q_FONT_DEFAULTS
	
creation
	make
	
feature{NONE} -- creation
	make( path_ : STRING ) is
		do
			create defaults.make_and_read( path_ )
		end
		
feature{NONE}
	defaults : Q_INI_FILE_READER
		
	get( component_, key_ : STRING ) : STRING is
		do
			result := defaults.value( component_, key_ )
			if result = void then
				result := defaults.value( "default", key_ )
			end
		end
		
		
feature -- access
	font( component_ : STRING ) : Q_HUD_FONT is
		do
			result := create {Q_HUD_IMAGE_FONT}.make_standard(
				name( component_ ), size( component_ ), bold( component_ ), italic( component_ ))
		end
		
	name( component_ : STRING ) : STRING is
		do
			result := get( component_, "name" )
		end
		
	size( component_ : STRING ) : INTEGER is
		do
			result := get( component_, "size" ).to_integer
		end
		
	bold( component_ : STRING ) : BOOLEAN is
		do
			result := get( component_, "bold" ).to_boolean
		end
		
	italic( component_ : STRING ) : BOOLEAN is
		do
			result := get( component_, "italic" ).to_boolean
		end
		

end -- class Q_FONT_DEFAULTS
