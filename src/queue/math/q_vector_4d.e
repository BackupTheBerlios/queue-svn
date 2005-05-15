indexing
	description: "4 dimensional vector"
	author: "Benjamin Sigg"

class
	Q_VECTOR_4D
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
			make( 0, 0, 0, 0 )
		end
		
	make( x_, y_, z_, t_ : DOUBLE) is
		do
			set_x( x_ )
			set_y( y_ )
			set_z( z_ )
			set_t( t_ )
		end
		
	make_from( vector_ : Q_VECTOR_4D ) is
		do
			make( vector_.x, vector_.y, vector_.z, vector_.t )
		end
		
feature -- openGL interface
	set_open_gl( open_gl : Q_GL_DRAWABLE ) is
			-- sets this vector as vertex3d
		require
			open_gl_not_void : open_gl /= void
		do
			open_gl.gl.gl_vertex4d( x, y, z, t )
		end
		

feature -- coordinates
	x, y, z, t : DOUBLE
	
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
		
	set_t( t_ : DOUBLE ) is
		do
			t := t_
		end

	get( index_ : INTEGER ) : DOUBLE is
		do
			inspect index_
			when 1 then result := x
			when 2 then result := y
			when 3 then result := z
			when 4 then result := t
			end
		end
		
	set( index_ : INTEGER; value_ : DOUBLE ) is
		do
			inspect index_
			when 1 then set_x( value_ )
			when 2 then set_y( value_ )
			when 3 then set_z( value_ )
			when 4 then set_t( value_ )
			end
		end
		

feature -- modification
	swap( index_a_, index_b_ : INTEGER ) is
			-- 
		local
			t_ : DOUBLE
		do
			t_ := get( index_a_ )
			set( index_a_, get( index_b_ ))
			set( index_b_, t_ )
		end
		

	sum, infix "+" (vector_ : Q_VECTOR_4D ) : Q_VECTOR_4D is
			-- calculates the sum of this and another vector, returns a new vector with the result
		do
			create result.make( vector_.x + x, vector_.y + y, vector_.z + z, vector_.t + t )
		end
		
	diff, infix "-" (vector_ : Q_VECTOR_4D ) : Q_VECTOR_4D is
			-- calculates the differenz of this and another vector, returns a new vector with the result
		do
			create result.make( x - vector_.x, y - vector_.y, z - vector_.z, t - vector_.t )
		end	

	add( vector_ : Q_VECTOR_4D ) is
			-- Adds another vector to this
		do
			set_x( x + vector_.x )
			set_y( y + vector_.y )
			set_z( z + vector_.z )
			set_t( t + vector_.t )
		end

	sub( vector_ : Q_VECTOR_4D ) is
			-- subtracts another vector from this
		do
			set_x( x - vector_.x )
			set_y( y - vector_.y )
			set_z( z - vector_.z )
			set_t( t - vector_.t )
		end
		

	dot, scalar_product( vector_ : Q_VECTOR_4D ) : DOUBLE is
			-- calculates the scalarproduct of two vectors
		do
			result := vector_.x * x + vector_.y * y + vector_.z * z + vector_.t * t
		end

	scaled( scalar_ : DOUBLE ) is
			-- scales this vector
		do
			set_x( x * scalar_ )
			set_y( y * scalar_ )
			set_z( z * scalar_ )
			set_t( t * scalar_ )
		end

	scale(scalar_ : DOUBLE ) : Q_VECTOR_4D is
			-- creates a new scaled vector-instance
		do
			create result.make ( x * scalar_, y * scalar_, z * scalar_, t * scalar_ )
		end
		
	length : DOUBLE is
			-- Calculates the length of this vector
		do
			result := math.sqrt( x*x + y*y + z*z + t*t )
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
			set_t( t / length_ )
		end
		
	normalice : Q_VECTOR_4D is
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
		

end -- class Q_VECTOR_4D
