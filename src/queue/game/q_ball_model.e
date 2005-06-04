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
	make_from_file

feature -- Interface
	draw( open_gl : Q_GL_DRAWABLE ) is
		-- paint the table
	do
		model.draw (open_gl)
	end
	
	model: Q_GL_GROUP[Q_GL_MODEL]
		-- the model

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
			model := loader.create_flat_model
		end
		

end -- class Q_BALL_MODEL
