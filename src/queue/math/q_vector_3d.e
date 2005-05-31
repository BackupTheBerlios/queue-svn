indexing
	description: "A 3 dimensional vector"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_VECTOR_3D

inherit
	ANY
	redefine
		default_create
	end

creation
	default_create, make, make_from
	
feature{NONE} -- creation
	default_create is
		do
			precursor
			make( 0, 0, 0 )
		end
		
	make( x_, y_, z_ : DOUBLE) is
		do
			set_x( x_ )
			set_y( y_ )
			set_z( z_ )
		end
		
	make_from( vector_ : Q_VECTOR_3D ) is
		do
			make( vector_.x, vector_.y, vector_.z )
		end
		
feature -- openGL interface
	set( open_gl : Q_GL_DRAWABLE ) is
			-- sets this vector as vertex3d
		require
			open_gl_not_void : open_gl /= void
		do
			open_gl.gl.gl_vertex3d( x, y, z )
		end
		

feature -- coordinates
	x, y, z : DOUBLE
	
	set_x( x_ : DOUBLE ) is
		do
			x := x_
		end
		
	set_y( y_ : DOUBLE ) is
		do
			y := y_
		end
		
	set_z( z_ : DOUBLE ) is
		do
			z := z_
		end	

feature -- modification
	sum, infix "+" (vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
			-- calculates the sum of this and another vector, returns a new vector with the result
		do
			create result.make( vector_.x + x, vector_.y + y, vector_.z + z )
		end
		
	diff, infix "-" (vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
			-- calculates the differenz of this and another vector, returns a new vector with the result
		do
			create result.make( x - vector_.x, y - vector_.y, z - vector_.z )
		end	

	add( vector_ : Q_VECTOR_3D ) is
			-- Adds another vector to this
		do
			set_x( x + vector_.x )
			set_y( y + vector_.y )
			set_z( z + vector_.z )
		end
	
	add_xyz( x_, y_, z_ : DOUBLE ) is
			-- Addds the values of another vector to this
		do
			set_x( x + x_ )
			set_y( y + y_ )
			set_z( z + z_ )
		end
		
	
	sub( vector_ : Q_VECTOR_3D ) is
			-- subtracts another vector from this
		do
			set_x( x - vector_.x )
			set_y( y - vector_.y )
			set_z( z - vector_.z )
		end
		

	dot, scalar_product( vector_ : Q_VECTOR_3D ) : DOUBLE is
			-- calculates the scalarproduct of two vectors
		do
			result := vector_.x * x + vector_.y * y + vector_.z * z
		end

	cross, cross_product( vector_ : Q_VECTOR_3D ) : Q_VECTOR_3D is
			-- calculates the cross-product with another vector
		do
			create result.make(
      			y * vector_.z - z * vector_.y,
      			z * vector_.x - x * vector_.z,
      			x * vector_.y - y * vector_.x )
		end

	scaled( scalar_ : DOUBLE ) is
			-- scales this vector
		do
			set_x( x * scalar_ )
			set_y( y * scalar_ )
			set_z( z * scalar_ )
		end

	scale(scalar_ : DOUBLE ) : Q_VECTOR_3D is
			-- creates a new scaled vector-instance
		do
			create result.make ( x * scalar_, y * scalar_, z * scalar_ )
		end
		
	length : DOUBLE is
			-- Calculates the length of this vector
		do
			result := math.sqrt( x*x + y*y + z*z )
		end

	normaliced is
			-- changes the length of this vector, so it fits 1
			-- if this vector is the 0/0/0, the behaviour is unspecified
		local
			length_ : DOUBLE
		do
			length_ := length
			set_x( x / length_ )
			set_y( y / length_ )
			set_z( z / length_ )
		end
		
	normalice : Q_VECTOR_3D is
			-- generates a normaliced version of this vector
		do
			create result.make_from( current )
			result.normaliced
		end

feature{NONE} -- implementation
	math : DOUBLE_MATH is
		once
			create result
		end
		

end -- class Q_VECTOR_3D
