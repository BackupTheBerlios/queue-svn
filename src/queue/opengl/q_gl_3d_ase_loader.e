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
	description: "A object loader for the 3d Studio Max ase export file format."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class	
	Q_GL_3D_ASE_LOADER

inherit 
	Q_GL_3D_LOADER

create
	make

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
		do
			create scanner.make_from_string_with_delimiters ("", " %T")

			create ase_file_.make_open_read (a_filename)
			-- read line for line
			from
				ase_file_.read_line
			until
				ase_file_.after
			loop				
				if not ase_file_.last_string.is_empty then
					
					scanner.set_source_string (ase_file_.last_string)
					scanner.read_token
					
					if scanner.last_string.is_equal ("*COMMENT") then
					elseif scanner.last_string.is_equal ("*3DSMAX_ASCIIEXPORT") then
						scanner.read_token
						file_version := scanner.last_string.to_integer
					elseif scanner.last_string.is_equal ("*SCENE") then
						-- ignore those for the moment
						read_subclause(ase_file_)
					elseif scanner.last_string.is_equal ("*MATERIAL_LIST") then
						-- ignore those for the moment
						read_materials (ase_file_)
					elseif scanner.last_string.is_equal ("*SHAPEOBJECT") then
						read_shape_object(ase_file_)				
					elseif scanner.last_string.is_equal ("*GEOMOBJECT") then
						read_geometric_object(ase_file_)				
					end
				end
				
				ase_file_.read_line
			end
		end
		
	create_flat_model : Q_GL_GROUP[Q_GL_FLAT_MODEL] is
			-- Create a flat object.
		local
			index_ : INTEGER
			
			model_ : Q_GL_FLAT_MODEL
			geom_obj_ : Q_GL_3D_ASE_GEOMOBJ
			
			material_ : Q_GL_MATERIAL
			ase_material_ : Q_GL_3D_ASE_MATERIAL
		do
			create result.make
			
			from
				index_ := geometric_objects.lower
			until
				index_ > geometric_objects.upper
			loop
				if geometric_objects.item(index_) /= void then
					geom_obj_ := geometric_objects.item(index_)
					model_ := geom_obj_.create_flat_model
					
					-- set the material
					if geom_obj_.color /= void then
						model_.set_material (create {Q_GL_MATERIAL}.make_single_colored (geom_obj_.color))
					else
						-- a material is present
						ase_material_ := materials.item(geom_obj_.material_index)
						create material_.make_empty
						material_.set_ambient (ase_material_.ambient)
						material_.set_diffuse (ase_material_.diffuse)
						material_.set_specular (ase_material_.specular)
						material_.set_shininess (ase_material_.shine)
						model_.set_material (material_)
						
						if ase_material_.diffuse_texutre /= void then
							model_.set_diffuse_texture (create {Q_GL_TEXTURE}.make (ase_material_.diffuse_texutre))	
						end
					end
					
					result.extend (model_)
				end
				index_ := index_ + 1
			end
		end
	
	create_index_model : Q_GL_INDEX_MODEL is
		do
		end
		
	create_shapes : Q_GL_GROUP[Q_GL_OBJECT] is
		local
			index_:INTEGER
		do
			create result.make
			from
				index_ := shape_objects.lower
			until
				index_ > shape_objects.upper
			loop
				if shape_objects.item (index_) /= void then
					result.extend( shape_objects.item(index_).create_primitve )	
				end
				index_ := index_ + 1
			end
		end
		
feature {NONE} -- Implementation
		
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
		
	read_materials (file_: PLAIN_TEXT_FILE) is
			-- parses the *MATERIAL_LIST clause
		local
			off_ : BOOLEAN
			
			index_ : INTEGER
		do
			from
				file_.read_line
			until
				file_.after or off_
			loop
				scanner.set_source_string (file_.last_string)
				scanner.read_token
				
				if scanner.last_string.is_equal ("*MATERIAL_COUNT") then
					scanner.read_token
					create materials.make (0, scanner.last_string.to_integer-1)
					file_.read_line
				elseif scanner.last_string.is_equal ("*MATERIAL") then
					scanner.read_token
					index_ := scanner.last_string.to_integer
					materials.force (create {Q_GL_3D_ASE_MATERIAL}.make(file_), index_)
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

feature -- access
	scanner: Q_TEXT_SCANNER

	file_version: INTEGER
	
	geometric_objects : ARRAY[Q_GL_3D_ASE_GEOMOBJ]
	
	geometric_object_count : INTEGER
	
	shape_objects : ARRAY[Q_GL_3D_ASE_SHAPEOBJ]
	
	shape_object_count : INTEGER
	
	materials : ARRAY[Q_GL_3D_ASE_MATERIAL]
	
	matieral_count : INTEGER
end
