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
	description: "Objects that represent a 3D-model of a ball"
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/06/03 $"
	revision: "$Revision: 1.0 $"
class
	Q_BALL_MODEL
	
inherit
	Q_GL_OBJECT
	redefine
		draw
	end

create
	make_from_file,
	make_from_loader_and_texture
		
feature -- Interface
	draw( open_gl : Q_GL_DRAWABLE ) is
		-- paint the table
	do
		transformation.transform (open_gl)
		rotation.transform (open_gl)
		if visible then			
			model.draw (open_gl)
		end
		rotation.untransform (open_gl)
		transformation.untransform (open_gl)
	end
	
	set_position (new_position: Q_VECTOR_3D) is
			-- set a new position
		require
			new_position /= void
		do
			transformation.set_translation (new_position + height_translation)
		end
	
	add_rotation (axis_: Q_VECTOR_3D; angle_: DOUBLE) is
			-- rotates the ball model
		require
			axis_ /= void
		do
			rotation.rotate_around (axis_,  angle_, middle_point)
		end
		
	set_visible(v_:BOOLEAN) is
			-- should the ball model be displayed?
		do
			visible := v_
		end
		
	
	model: Q_GL_FLAT_MODEL
		-- the model

	radius: DOUBLE
		-- the radius of the ball

feature {NONE} -- Properties
	middle_point: Q_VECTOR_3D

	transformation: Q_GL_TRANSLATION
	
	height_translation: Q_VECTOR_3D
	
	rotation: Q_GL_MULTI_ROTATION
	
	visible: BOOLEAN
feature {NONE} -- Creation
	make_from_file (file_name_: STRING) is
			-- Create a new ball model
		require
			file_name_ /= void
		local
			loader : Q_GL_3D_ASE_LOADER
		do	
			create loader.make
		
			-- create the modell	
			loader.load_file (file_name_)
			model := loader.create_flat_model.first
			
			calc_middle_point
			
			create height_translation.make (0, radius, 0)
			create transformation.make_from_vector (height_translation)
			create rotation.make
			visible := true
		end
		
	make_from_loader_and_texture (loader_: Q_GL_3D_ASE_LOADER; texture_: STRING) is
			-- Create a new ball model from preparsed geom-obj.
		require
			loader_ /= void
			texture_ /= void
		do
			loader_.materials.item (loader_.materials.lower).set_diffuse_texture (texture_)
			model := loader_.create_flat_model.first
			
			calc_middle_point
			
			create height_translation.make (0, radius, 0)
			create transformation.make_from_vector (height_translation)
			create rotation.make
			visible := true
		end		
		
	calc_middle_point is
			-- calculates the middle point
		local
			index_ : INTEGER
			
			positions_: ARRAY[Q_GL_VERTEX]
			curr_: Q_GL_VERTEX
		do
			-- calculate the middle point
			create middle_point.default_create
			
			positions_ := model.vertices
			
			from
				index_ := positions_.lower
			until
				index_ > positions_.upper
			loop
				curr_ := positions_.item (index_)
				middle_point.add_xyz (curr_.x, curr_.y, curr_.z)
				
				index_ := index_ + 1
			end
			
			middle_point.scaled (1.0 / index_)

			curr_ := positions_.item (0)
			radius := (middle_point - create {Q_VECTOR_3D}.make (curr_.x, curr_.y, curr_.z)).length
		end
		
feature -- ball
	ball : Q_BALL
	
	set_ball( ball_ : Q_BALL ) is
		do
			ball := ball_
		end
		
		
invariant
	model /= void
	height_translation/= void

end -- class Q_BALL_MODEL
