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
	description: "An object representing the settings of a gl-material"
	author: "Benjamin Sigg"

class
	Q_GL_MATERIAL

creation
	make_empty, make_single_colored

feature{NONE} -- creation
	make_empty is
			-- default-constructor
		do
			set_face_front( true );
			set_face_back( true );
			set_shininess( 0 )
		end
		
	make_single_colored( default_ : Q_GL_COLOR ) is
			-- Creates a material with the base-color "default_"
		require
			default_not_void : default_ /= void
		do
			make_empty
			
			set_ambient( default_ )
			set_diffuse( default_ )
			set_specular( create {Q_GL_COLOR}.make_white )
		end
		

feature -- set
	set( open_gl : Q_GL_DRAWABLE ) is
			-- Sets the values of this material
		require
			open_gl_not_void : open_gl /= void
		local
			glf_ : GL_FUNCTIONS
			con_ : ESDL_GL_CONSTANTS
			
			face_ : INTEGER
		do
			if face_front or face_back then
				glf_ := open_gl.gl
				con_ := open_gl.gl_constants
				
				if face_front and face_back then
					face_ := con_.esdl_gl_front_and_back
				elseif face_front then
					face_ := con_.esdl_gl_front
				else -- if face_back
					face_ := con_.esdl_gl_back
				end
			
				if ambient /= void then
					glf_.gl_color_material( face_, con_.esdl_gl_ambient )
					ambient.set( open_gl )
				end	
				
				if diffuse /= void then
					glf_.gl_color_material( face_, con_.esdl_gl_diffuse )
					diffuse.set( open_gl )
				end
				
				if specular /= void then
					glf_.gl_color_material( face_, con_.esdl_gl_specular )
					specular.set( open_gl )
				end
				
				if emission /= void then
					glf_.gl_color_material( face_, con_.esdl_gl_emission )
					emission.set( open_gl )
				end
				
				if shininess /= void then
					glf_.gl_materialf( face_, con_.esdl_gl_shininess, shininess )  
				end				
			end
		end
		

feature -- colors
	face_front, face_back : BOOLEAN
		-- witch faces should be influenced by this material

	set_face_front( face_ : BOOLEAN ) is
		do
			face_front := face_
		end
		
	set_face_back( face_ : BOOLEAN ) is
		do
			face_back := face_
		end

	ambient : Q_GL_COLOR
	diffuse : Q_GL_COLOR
	specular : Q_GL_COLOR
	emission : Q_GL_COLOR
	shininess : REAL
	
	set_ambient( color_ : Q_GL_COLOR ) is
			-- Sets the ambient-color. Void means, that this
			-- field should be ignored
		do
			ambient := color_
		end

	set_diffuse( color_ : Q_GL_COLOR ) is
			-- Sets the diffuse-color. Void means, that this
			-- field should be ignored
		do
			diffuse := color_
		end
		
	set_specular( color_ : Q_GL_COLOR ) is
			-- Sets the specular-color. Void means, that this
			-- field should be ignored
		do
			specular := color_
		end
		
	set_emission( color_ : Q_GL_COLOR ) is
			-- Sets the emission-color. Void means, that this
			-- field should be ignored
		do
			emission := color_
		end
		
	set_shininess( shininess_ : REAL ) is
			-- Sets the shininess.
		require
			in_valid_bounds : shininess_ >= 0 and shininess_ <= 128
		do
			shininess := shininess_
		end

end -- class Q_GL_MATERIAL
