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
		rotation.transform (open_gl)
		transformation.transform (open_gl)
		model.draw (open_gl)
		transformation.untransform (open_gl)
		rotation.untransform (open_gl)
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
			rotation.rotate (axis_,  angle_)
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
		
invariant
	model /= void
	height_translation/= void

end -- class Q_BALL_MODEL
