indexing
	description: "Objects that ..."
	
class
	BEN_CONTAINER_3D_TEST


inherit
	Q_TEST_CASE
	Q_HUD_CONTAINER
	redefine
		draw
	end

creation
	make

feature
	container_a, container_b : Q_HUD_CONTAINER_3D

	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			matrix_ : Q_MATRIX_4X4
			vector_ : Q_VECTOR_3D
		do
			create matrix_.identity
			matrix_.rotate_at( 0, 0, 1, open_gl.current_time_millis / 2000,
				0.5, 0.5, 0 )
	--		vector_ := matrix_.translation_3
	--		matrix_.translate( vector_.x, vector_.y, vector_.z - 1 )
			container_b.set_matrix( matrix_ )

			matrix_.rotate_at( 0, 1, 0, open_gl.current_time_millis / 5000,
				0.5, 0.5, 0 )
			vector_ := matrix_.translation_3
			matrix_.translate( vector_.x, vector_.y, vector_.z - 1 )
			container_a.set_matrix( matrix_ )
			
			precursor( open_gl )
		end
		

	name : STRING is "Container 3D"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is do
		result := void
	end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			box_ : Q_HUD_CHECK_BOX
			index_ : INTEGER
		do
			create container_a.make
			create container_b.make
			container_a.set_bounds( 0, 0, 1, 1 )
			container_b.set_bounds( 0, 0, 1, 1 )
	
			container_a.add ( container_b )
			add( container_a )
	
			-- first container		
			from index_ := 1 until index_ = 9 loop
				create box_.make
				box_.set_bounds( 0.1, index_ * 0.1, 0.8, 0.09 )
				box_.set_text( "This is Box " + index_.out )
				container_b.add( box_ )
				
				index_ := index_ + 1
			end
			
			set_bounds( 0, 0, 1, 1 )
			result := current
		end		
		
	max_bound : Q_VECTOR_3D is do
		result := void
	end
		
	min_bound : Q_VECTOR_3D is do
		result := void
	end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		do
		end
end -- class BEN_CONTAINER_3D_TEST
