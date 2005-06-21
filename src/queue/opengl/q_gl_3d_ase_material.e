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
	description: "Represents the matieral associated with a geometrical object."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/06/02 $"
	revision: "$Revision: 1.0 $"

class
	Q_GL_3D_ASE_MATERIAL

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
				
				if scanner.last_string.is_equal ("*MATERIAL_NAME") then
					read_name_from_string (file_.last_string)
				elseif scanner.last_string.is_equal ("*MATERIAL_AMBIENT") then
					create ambient.make
					
					scanner.read_token
					ambient.set_red (scanner.last_string.to_double)
					
					scanner.read_token
					ambient.set_green (scanner.last_string.to_double)
					
					scanner.read_token
					ambient.set_blue (scanner.last_string.to_double)
				elseif scanner.last_string.is_equal ("*MATERIAL_DIFFUSE") then
					create diffuse.make
					
					scanner.read_token
					diffuse.set_red (scanner.last_string.to_double)
					
					scanner.read_token
					diffuse.set_green (scanner.last_string.to_double)
					
					scanner.read_token
					diffuse.set_blue (scanner.last_string.to_double)
				elseif scanner.last_string.is_equal ("*MATERIAL_SPECULAR") then
					create specular.make
					
					scanner.read_token
					specular.set_red (scanner.last_string.to_double)
					
					scanner.read_token
					specular.set_green (scanner.last_string.to_double)
					
					scanner.read_token
					specular.set_blue (scanner.last_string.to_double)
				elseif scanner.last_string.is_equal ("*MATERIAL_SHINE") then
					
					scanner.read_token
					shine := scanner.last_string.to_double
				elseif scanner.last_string.is_equal ("*MAP_DIFFUSE") then
					read_diffuse_texture(file_)
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
	
	read_diffuse_texture(file_: PLAIN_TEXT_FILE) is
			-- reads a diffuse texture map
		local
			off_ : BOOLEAN
			
			
			start_, end_: INTEGER
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*BITMAP") then
					
					start_ := file_.last_string.index_of ('"', 1)
					end_ := file_.last_string.index_of ('"', start_ + 1)
					
					diffuse_texutre := file_.last_string.substring (start_ + 1, end_ - 1)
					
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

feature -- Settings
	set_diffuse_texture (new_texture: STRING) is
			-- set a new diffuse texture
		require
			new_texture /= void
		do
			diffuse_texutre := new_texture
		end
		

feature -- Access
	name : STRING
	
	ambient : Q_GL_COLOR
	
	diffuse : Q_GL_COLOR
	diffuse_texutre : STRING
	
	specular : Q_GL_COLOR
	
	shine : DOUBLE

end -- class Q_GL_3D_ASE_MATERIAL
