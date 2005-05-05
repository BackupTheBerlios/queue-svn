indexing
	description: "A class capsulating a complete vertex."
	author: "Basil Fierz, bfierz@student.ethz.ch"
	date: "$Date: 2005/05/04 $"
	revision: "$Revision: 1.0 $"

class Q_GL_VERTEX
   
feature -- setter
	set_position (new_x, new_y, new_z:DOUBLE) is
			-- set the position
		do
			x := new_x
			y := new_y
			z := new_z
		end
		
	set_normal (new_nx, new_ny, new_nz:DOUBLE) is
			-- set the position
		do
			nx := new_nx
			ny := new_ny
			nz := new_nz
		end
		
	set_texture_coordinates (new_tu, new_tv:DOUBLE) is
			-- set the position
		do
			tu := new_tu
			tv := new_tv
		end
		
   
feature -- access
	x, y, z: DOUBLE
		-- Coordinates

	tu, tv: DOUBLE
		-- Texture coordinates
	
	nx, ny, nz: DOUBLE
		-- Normal
end
