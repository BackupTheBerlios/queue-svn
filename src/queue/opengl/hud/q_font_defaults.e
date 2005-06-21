--
--  queue
--
--  Copyright (C) 2005  
--  Basil Fierz, Severin Hacker, Andreas Kaegi, Benjamin Sigg
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 2 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU Library General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
--

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
