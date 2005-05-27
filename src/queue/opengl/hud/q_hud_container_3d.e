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

end -- class Q_HUD_CONTAINER_3D
