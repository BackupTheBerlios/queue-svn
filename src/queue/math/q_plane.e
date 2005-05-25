indexing
	description: "A 3dimensional plane"
	author: "Benjamin Sigg"

class
	Q_PLANE
	
creation
	make_empty, make, make_normal, make_vectorized

feature -- Creation
	make_empty is
		do
			set( 0, 1, 0, 0 )
		end
		
	make( a_, b_, c_, d_ : DOUBLE ) is
		do
			set( a_, b_, c_, d_ )
		end
	
	make_normal( position_, normal_ : Q_VECTOR_3D ) is
		do
			set_a( normal_.x )
			set_b( normal_.y )
			set_c( normal_.z )
			set_d( -a*position_.x - b*position_.y - c*position_.z )
		end
		
	make_vectorized( position_, direction_a_, direction_b_ : Q_VECTOR_3D ) is
		do
			make_normal( position_, direction_a_.cross( direction_b_ ))
		end
		
	
feature -- values
	a, b, c, d : DOUBLE
		-- The values descriping the plane.
		-- For any point in the plane, "a*x + b*y + c*z + d = 0" is true
	
	set_a( a_ : DOUBLE ) is
		do
			a := a_
		end
		
	set_b( b_ : DOUBLE ) is
		do
			b := b_
		end
		
	set_c( c_ : DOUBLE ) is
		do
			c := c_
		end
		
	set_d( d_ : DOUBLE ) is
		do
			d := d_
		end

	set( a_, b_, c_, d_ : DOUBLE ) is
		do
			a := a_
			b := b_
			c := c_
			d := d_
		end
	
	normal : Q_VECTOR_3D is
		do
			create result.make( a, b, c )
		end
	
feature -- Geometric
	equals_toleranced( other_ : Q_PLANE; tolerance_ : DOUBLE ) : BOOLEAN is
			-- returns true, if the other plane is parallel to this plane, and
			-- at the same position in space. The tolerance_-value tells, how
			-- great the relative error is allowed to be
		local
			ratio_a_, ratio_b_, ratio_c_, ratio_d_, middle_ : DOUBLE
		do
			ratio_a_ := a / other_.a
			ratio_b_ := b / other_.b
			ratio_c_ := c / other_.c
			ratio_d_ := d / other_.d
			
			middle_ := (ratio_a_ + ratio_b_ + ratio_c_ + ratio_d_ ) / 4
			
			result :=
				( middle_ - ratio_a_ ).abs <= (middle_ * tolerance_) and
				( middle_ - ratio_b_ ).abs <= (middle_ * tolerance_) and
				( middle_ - ratio_c_ ).abs <= (middle_ * tolerance_) and
				( middle_ - ratio_d_ ).abs <= (middle_ * tolerance_)
		end
		
	cut_distance( position_, direction_ : Q_VECTOR_3D ) : DOUBLE is
			-- "result*direction_+positon_" gives the point in witch this
			-- plane and the line "position, direction" cuts
		do

		end
		
		
feature {NONE} -- Math
	math : DOUBLE_MATH is
		once
			create result
		end
		
	not_a_number : DOUBLE is
		once
			
		end
		
		
end -- class Q_PLANE
