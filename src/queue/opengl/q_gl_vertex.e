indexing
	description: "A class capsulating a complete vertex."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

class Q_GL_VERTEX
   
feature
	x, y, z: DOUBLE
		-- Coordinates

	tu, tv: DOUBLE
		-- Texture coordinates
	
	nx, ny, nz: DOUBLE
		-- Normal
end
