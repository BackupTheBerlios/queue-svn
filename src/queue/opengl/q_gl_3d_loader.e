indexing
	description: "Deferred class serving as base for different 3d file loaders."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

deferred class
	Q_GL_3D_LOADER

feature
	load_file (a_filename: STRING) is
	deferred
	end

end
