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
	description: "A container who rotates, translates and scales its children"
	author: "Benjamin Sigg"

class
	Q_HUD_CONTAINER_3D
	
inherit
	Q_HUD_CONTAINER
	redefine
		make,
		draw,
		enqueue
	end

creation
	make

feature{NONE} -- creation
	make is
	do
		precursor
		create matrix.identity
	end
		

feature -- drawing
	enqueue( queue_ : Q_HUD_QUEUE ) is
		do
			queue_.push_matrix
			queue_.matrix_multiplication( matrix )
			precursor( queue_ )
			queue_.pop_matrix
		end
		

	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_push_matrix
			matrix.set( open_gl )
			precursor( open_gl )			
			open_gl.gl.gl_pop_matrix
		end

feature{NONE} -- Matrix
	matrix : Q_MATRIX_4X4

feature -- Conversion
	
	set_matrix( matrix_ : Q_MATRIX_4X4 ) is
			-- Makes a copy of the matrix, and sets the copy
			-- as the transformationmatrix of this container 3d
		do
			create matrix.copy( matrix_ )
		end
		
	get_matrix : Q_MATRIX_4X4 is
		do
			create result.copy( matrix )
		end
	
	translate( dx_, dy_, dz_ : DOUBLE ) is
			-- translates the container.
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.translate( dx_, dy_, dz_ )
			
			set_matrix( matrix.mul( matrix_ ) )
		end

	scale( sx_, sy_, sz_ : DOUBLE ) is
			-- scales the container
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.scale( sx_, sy_, sz_ )
			
			set_matrix( matrix.mul( matrix_ ) )
		end
		
	rotate( ax_, ay_, az_, angle_ : DOUBLE ) is
		-- rotates the container
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.rotate( ax_ , ay_, az_, angle_ )
			
			set_matrix( matrix.mul( matrix_ ) )
		end
		
	rotate_around( ax_, ay_, az_, angle_, px_, py_, pz_ : DOUBLE ) is
			-- rotates the container around a point
		local
			matrix_ : Q_MATRIX_4X4
		do
			create matrix_.identity
			matrix_.rotate_at( ax_, ay_, az_, angle_, px_, py_, pz_ )
			
			set_matrix( matrix.mul( matrix_ ) )
		end
		

end -- class Q_HUD_CONTAINER_3D
