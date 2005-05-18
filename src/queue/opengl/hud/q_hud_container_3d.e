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
		convert_direction,
		convert_point
	end

creation
	make

feature{NONE} -- creation
	make is
	do
		precursor
		create matrix.identity
		inverse := matrix.inverted
	end
		

feature -- drawing
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
			open_gl.gl.gl_push_matrix
			matrix.set( open_gl )
			precursor( open_gl )			
			open_gl.gl.gl_pop_matrix
		end

feature{NONE} -- Matrix
	matrix : Q_MATRIX_4X4
	inverse  : Q_MATRIX_4X4

feature -- Conversion
	
	set_matrix( matrix_ : Q_MATRIX_4X4 ) is
			-- Makes a copy of the matrix, and sets the copy
			-- as the transformationmatrix of this container 3d
		do
			create matrix.copy( matrix_ )
			inverse := matrix.inverted
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

	convert_direction (direction_: Q_VECTOR_3D): Q_VECTOR_3D is
		do
			result := inverse.mul_vector_3( direction_ )
		end

	convert_point (x_, y_: DOUBLE; direction_: Q_VECTOR_3D): Q_VECTOR_2D is
		local
			position_, direction_a_, direction_b_ : Q_VECTOR_3D
			system_ : ARRAY[ DOUBLE ]
		do
			create position_.make( 0, 0, 0 )
			create direction_a_.make( 1, 0, 0 )
			create direction_b_.make( 0, 1, 0 )
			
			position_ := matrix.mul_vector_3_as_4( position_ )
			direction_a_ := matrix.mul_vector_3( direction_a_ )
			direction_b_ := matrix.mul_vector_3( direction_b_ )
			
			system_ := (create {Q_GEOM_3D}).cut_plane_line_sizes(
				position_, direction_a_, direction_b_,
				create {Q_VECTOR_3D}.make( x_ - x, y_ - y, 0 ), direction_ )
				
			if system_ = void then
				create result.make( 0, 0 )
			else
				create result.make( system_.item( 1 ), system_.item( 2 ))
			end
		end

end -- class Q_HUD_CONTAINER_3D
