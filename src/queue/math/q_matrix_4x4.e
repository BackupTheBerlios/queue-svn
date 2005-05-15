indexing
	description: "A 4x4-Matrix"
	author: "Benjamin Sigg"

class
	Q_MATRIX_4X4
	
inherit
	ANY
	redefine
		default_create, copy
	end
	
creation
	default_create, zero, identity, copy
	
feature {NONE} -- creation
	default_create is
		do
			precursor
			zero
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

	translate( dx_, dy_, dz_ : DOUBLE ) is
			-- changes the translation of this matrix.
			-- Other values will not be influenced
		do
			m_14 := dx_
			m_24 := dy_
			m_34 := dz_
		end

	scale( sx_, sy_, sz_ : DOUBLE ) is
			-- Changes this matrix into a matrix witch scales vectors.
			-- the translation-part will not be influenced
		do
			m_11 := sx_
			m_22 := sy_
			m_33 := sz_
			
			m_12 := 0
			m_13 := 0
			m_21 := 0
			m_23 := 0
			m_31 := 0
			m_32 := 0
		end
		

	rotate_vector( vector_ : Q_VECTOR_3D; angle_ : DOUBLE ) is
			-- see "rotate"
		do
			rotate( vector_.x, vector_.y, vector_.z, angle_ )
		end
		

	rotate( vx__, vy__, vz__, angle_ : DOUBLE ) is
			-- Sets the top left 3x3 Submatrix to a matrix describig 
			-- a rotation around the v-Vector and with an angle
			-- given in radians (clockwise).
			
			-- for more informations, please visit
			-- http://www.opengl.org/documentation/specs/man_pages/hardcopy/GL/html/gl/rotate.html
			-- http://www.makegames.com/3drotation/
		require
			not_0_vector : vx__ /= 0 or vy__ /= 0 or vz__ /= 0
		local
			s_, c_, u_ : DOUBLE
			length_, vx_, vy_, vz_ : DOUBLE
		do
			length_ := math.sqrt( vx__*vx__ + vy__*vy__ + vz__*vz__ )
			
			vx_ := vx__ / length_
			vy_ := vy__ / length_
			vz_ := vz__ / length_
			
			s_ := math.sine( angle_ )
			c_ := math.cosine( angle_ )
			u_ := 1 - c_

			
			set_m_11( vx_*vx_*u_ + c_ )
			set_m_21( vx_*vy_*u_ + vz_*s_ )
			set_m_31( vx_*vz_*u_ - vy_*s_ )
			
			set_m_12( vy_*vx_*u_ - vz_*s_ )
			set_m_22( vy_*vy_*u_ + c_ )
			set_m_32( vy_*vz_*u_ + vx_*s_ )
			
			set_m_13( vz_*vx_*u_ + vy_*s_ )
			set_m_23( vz_*vy_*u_ - vx_*s_ )
			set_m_33( vz_*vz_*u_ + c_ )
		end
	
	orthonormalize_3x3 is
			-- Orthonormalises the Vectors (m_1i, m_2i, m_3i) for i = 1, 2, 3
			-- If the current matrix is a bijective projection, afterwards this 
			-- matrix will be a projection on witch followings holds:
			-- <a, b> = <M*a, M*b> for all vectors a, b and M = current
			-- morover: |a| = |M*a| for all vectors a and M = current
			
			-- this is an implementation of Gram-Schmidt
		local
			a1_, a2_, a3_ : Q_VECTOR_3D
			b1_, b2_, b3_ : Q_VECTOR_3D
		do
			create a1_.make( m_11, m_21, m_31 )
			create a2_.make( m_12, m_22, m_32 )
			create a3_.make( m_13, m_23, m_33 )
			
			b1_ := a1_.normalice
			
			b2_ := a2_ - b1_.scale( b1_.scalar_product( a2_ ) )
			b2_.normaliced
			
			b3_ := a3_ - b1_.scale( b1_.scalar_product( a3_ )) - b2_.scale ( b2_.scalar_product( a3_ ) )
			b3_.normaliced
			
			set_column_vector_3d( 1, b1_ )
			set_column_vector_3d( 2, b2_ )
			set_column_vector_3d( 3, b3_ )
		end

feature -- operations
	copy( matrix_ : like current ) is
			-- copies the values of another matrix into this one
		local
			row_, column_ : INTEGER
		do
			from row_ := 1 until row_ > 4 loop
				from column_ := 1 until column_ > 4 loop
					set_m( row_, column_, matrix_.m( row_, column_ ))
				end
			end
		end
		

	mul, infix "*" (matrix_ : Q_MATRIX_4X4 ) : Q_MATRIX_4X4 is
			-- Multiplicates this matrix with another matrix and returns the result as a new matrix
			
		local
			row_, column_, index_ : INTEGER
			temp_ : DOUBLE
		do
			create result
			
			from row_ := 1 until row_ > 4 loop
				from column_ := 1 until column_ > 4 loop
					temp_ := 0
					from index_ := 1 until index_ > 4 loop
						temp_ := temp_ + m( row_, index_ ) * matrix_.m( index_, column_ )
					end
					result.set_m( row_, column_, temp_ )
				end
			end
		end
		
	sum, infix "+" (matrix_ : Q_MATRIX_4X4 ) : Q_MATRIX_4X4 is
			-- Create a new matrix with the sum of this and another matrix
		do
			create result.copy( current )
			result.add( matrix_ )
		end
		
	add( matrix_ : Q_MATRIX_4X4 ) is
			-- Adds the value of another matrix to this
		local
			row_, column_ : INTEGER
		do
			from row_ := 1 until row_ > 4 loop
				from column_ := 1 until column_ > 4 loop
					set_m( row_, column_, m(row_, column_) + matrix_.m( row_, column_ ))
				end
			end
		end
		
	diff, infix "-" (matrix_ : Q_MATRIX_4X4 ) : Q_MATRIX_4X4 is
			-- Creates a new matrix containing the differenz between this and another matrix
		do
			create result.copy( current )
			result.sub( matrix_ )
		end

	sub( matrix_ : Q_MATRIX_4X4 ) is
			-- Subtracts another matrix from this
		local
			row_, column_ : INTEGER
		do
			from row_ := 1 until row_ > 4 loop
				from column_ := 1 until column_ > 4 loop
					set_m( row_, column_, m(row_, column_) - matrix_.m( row_, column_ ))
				end
			end
		end		
	
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
	
	m( row_, column_ : INTEGER ) : DOUBLE is
		require
			row_ >= 1 and row_ <= 4
			column_ >= 1 and column_ <= 4
		do
			inspect row_
				when 1 then
					inspect column_
						when 1 then
							result := m_11
						when 2 then
							result := m_12
						when 3 then
							result := m_13
						when 4 then
							result := m_14
					end
				when 2 then
					inspect column_
						when 1 then
							result := m_21
						when 2 then
							result := m_22
						when 3 then
							result := m_23
						when 4 then
							result := m_24
					end					
				when 3 then
					inspect column_
						when 1 then
							result := m_31
						when 2 then
							result := m_32
						when 3 then
							result := m_33
						when 4 then
							result := m_34
					end			
				when 4 then					
					inspect column_
						when 1 then
							result := m_41
						when 2 then
							result := m_42
						when 3 then
							result := m_43
						when 4 then
							result := m_44
					end				
			end
		end
		
	
	set_m( row_, column_ : INTEGER; m_ : DOUBLE ) is
		require
			row_ >= 1 and row_ <= 4
			column_ >= 1 and column_ <= 4
		do
			inspect row_
				when 1 then
					inspect column_
						when 1 then
							set_m_11( m_ )
						when 2 then
							set_m_12( m_ )
						when 3 then
							set_m_13( m_ )
						when 4 then
							set_m_14( m_ )
					end
				when 2 then
					inspect column_
						when 1 then
							set_m_21( m_ )
						when 2 then
							set_m_22( m_ )
						when 3 then
							set_m_23( m_ )
						when 4 then
							set_m_24( m_ )
					end					
				when 3 then
					inspect column_
						when 1 then
							set_m_31( m_ )
						when 2 then
							set_m_32( m_ )
						when 3 then
							set_m_33( m_ )
						when 4 then
							set_m_34( m_ )
					end			
				when 4 then					
					inspect column_
						when 1 then
							set_m_41( m_ )
						when 2 then
							set_m_42( m_ )
						when 3 then
							set_m_43( m_ )
						when 4 then
							set_m_44( m_ )
					end				
			end
		end
		
	set_column_vector_3d( column_ : INTEGER; vector_ : Q_VECTOR_3D ) is
		do
			set_m( 1, column_, vector_.x )
			set_m( 2, column_, vector_.y )
			set_m( 3, column_, vector_.z )
		end
		
		
feature -- openGL-interface
	set( open_gl : Q_GL_DRAWABLE ) is
			-- sets this matrix
		require
			open_gl_not_void : open_gl /= void
		local
			array_ : ARRAY[DOUBLE]
			intern_ : ANY
		do
			create array_.make(0, 15 )
			
			array_.put( m_11,  0 )
			array_.put( m_21,  1 )
			array_.put( m_31,  2 )
			array_.put( m_41,  3 )
			
			array_.put( m_12,  4 )
			array_.put( m_22,  5 )
			array_.put( m_32,  6 )
			array_.put( m_42,  7 )
			
			array_.put( m_13,  8 )
			array_.put( m_23,  9 )
			array_.put( m_33, 10 )
			array_.put( m_43, 11 )
			
			array_.put( m_14, 12 )
			array_.put( m_24, 13 )
			array_.put( m_34, 14 )
			array_.put( m_44, 15 )
			
			intern_ := array_.to_c
			open_gl.gl.gl_mult_matrixd ( $intern_ )
		end

feature{NONE} -- math
	math : DOUBLE_MATH is
		once
			create result
		end
		

end -- class Q_MATRIX_4X4