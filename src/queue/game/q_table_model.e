indexing
	description: "Objects that represent a 3D-model of the table"
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/12 $"
	revision: "$Revision: 1.0 $"

class
	Q_TABLE_MODEL

inherit
	Q_GL_OBJECT
	redefine
		draw
	end

create
	make_from_file

feature -- Interface
	draw( open_gl : Q_GL_DRAWABLE ) is
		-- paint the table
	do
		model.draw (open_gl)
		shapes.draw (open_gl)
		
		
	end
	
	model : Q_GL_GROUP[Q_GL_MODEL]
		-- the model
		
	shapes : Q_GL_GROUP[Q_GL_OBJECT]
		-- bounding shapes

feature -- coordinate-system
	position_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			
		end
	
	direction_table_to_world( table_ : Q_VECTOR_2D ) : Q_VECTOR_3D is
		do
			
		end
		
	position_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			
		end
		
	direction_world_to_table( world_ : Q_VECTOR_3D ) : Q_VECTOR_2D is
		do
			
		end
		

feature {NONE} -- Implementation
	make_from_file (file_name_: STRING) is
			-- create the model from out of a file
		require
			file_name_ /= void
		local
			loader : Q_GL_3D_ASE_LOADER
		do
			create loader.make
			
			loader.load_file (file_name_)
			model := loader.create_flat_model
			
			--shapes := loader.create_shapes
		end
		
end -- class Q_TABLE_MODEL
