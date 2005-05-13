indexing
	description: "A 4x4-Matrix"
	author: "Benjamin Sigg"

class
	Q_MATRIX_4X4
	
creation
	make
	
feature {NONE} -- creation
	make is
		do
			identity
		end
		

feature -- matrix-modes
	zero is
			-- Sets all element to 0
		do
			m_11 := 0
			m_12 := 0
			m_13 := 0
			m_14 := 0
			
			m_21 := 0
			m_22 := 0
			m_23 := 0
			m_24 := 0
			
			m_31 := 0
			m_32 := 0
			m_33 := 0
			m_34 := 0
			
			m_41 := 0
			m_42 := 0
			m_43 := 0
			m_44 := 0
		end
		
	
	identity is
			-- loads the identity Matrix I4 into this matrix
		do
			zero
			
			m_11 := 1.0
			m_22 := 1.0
			m_33 := 1.0
			m_44 := 1.0
		end

	translated( dx_, dy_, dz_ : DOUBLE ) is
			-- changes the translation of this matrix.
			-- Other values will not be influenced
		do
			m_14 := dx_
			m_24 := dy_
			m_34 := dz_
		end

	rotate_vector( vector_ : Q_VECTOR_3D; angle_ : DOUBLE ) is
			-- see "rotate"
		do
			rotate( vector_.x, vector_.y, vector_.z, angle_ )
		end
		

	rotate( vx_, vy_, vz_, angle_ : DOUBLE ) is
			-- Sets the top left 3x3 Submatrix to a matrix describig 
			-- a rotation around the v-Vector and with an angle
			-- given in radians.
		local
			s_, c_, u_ : DOUBLE
		do
			s_ := math.sine( angle_ )
			c_ := math.cosine( angle_ )
			u_ := 1 - c_
			
			set_m_11( vx_*vx_*u_ + c_ )
			set_m_21( vx_*vy_*u_ + vz_*s_ )
			set_m_31( vx_*vz_*u_ - vy_*s_ )
			
			set_m_21( vy_*vx_*u_ - vz_*s_ )
			set_m_22( vy_*vy_*u_ + c_ )
			set_m_23( vy_*vz_*u_ + vx_*s_ )
			
			set_m_31( vz_*vx_*u_ + vy_*s_ )
			set_m_32( vz_*vy_*u_ - vx_*s_ )
			set_m_33( vz_*vz_*u_ + c_ )
		end
		

feature -- operations

feature -- elements
	m_11, m_12, m_13, m_14 : DOUBLE
	m_21, m_22, m_23, m_24 : DOUBLE
	m_31, m_32, m_33, m_34 : DOUBLE
	m_41, m_42, m_43, m_44 : DOUBLE
	
	set_m_11( m_ : DOUBLE ) is do m_11 := m_ end
	set_m_12( m_ : DOUBLE ) is do m_12 := m_ end
	set_m_13( m_ : DOUBLE ) is do m_13 := m_ end
	set_m_14( m_ : DOUBLE ) is do m_14 := m_ end

	set_m_21( m_ : DOUBLE ) is do m_21 := m_ end
	set_m_22( m_ : DOUBLE ) is do m_22 := m_ end
	set_m_23( m_ : DOUBLE ) is do m_23 := m_ end
	set_m_24( m_ : DOUBLE ) is do m_24 := m_ end
	
	set_m_31( m_ : DOUBLE ) is do m_31 := m_ end
	set_m_32( m_ : DOUBLE ) is do m_32 := m_ end
	set_m_33( m_ : DOUBLE ) is do m_33 := m_ end
	set_m_34( m_ : DOUBLE ) is do m_34 := m_ end
	
	set_m_41( m_ : DOUBLE ) is do m_41 := m_ end
	set_m_42( m_ : DOUBLE ) is do m_42 := m_ end
	set_m_43( m_ : DOUBLE ) is do m_43 := m_ end
	set_m_44( m_ : DOUBLE ) is do m_44 := m_ end
	
feature -- openGL-interface
	set( open_gl : Q_GL_DRAWABLE ) is
			-- sets this matrix
		require
			open_gl_not_void : open_gl /= void
		local
			array_ : ARRAY[DOUBLE]
		do
			create array_.make(0, 15 )
			
			array_.put( m_11,  0 )
			array_.put( m_12,  1 )
			array_.put( m_13,  2 )
			array_.put( m_14,  3 )
			
			array_.put( m_21,  4 )
			array_.put( m_22,  5 )
			array_.put( m_23,  6 )
			array_.put( m_24,  7 )
			
			array_.put( m_31,  8 )
			array_.put( m_32,  9 )
			array_.put( m_33, 10 )
			array_.put( m_34, 11 )
			
			array_.put( m_41, 12 )
			array_.put( m_42, 13 )
			array_.put( m_43, 14 )
			array_.put( m_44, 15 )
			
			open_gl.gl.gl_load_matrixd( $array_ )
		end
		
feature{NONE} -- math
	math : DOUBLE_MATH is
		once
			create result
		end
		

end -- class Q_MATRIX_4X4
