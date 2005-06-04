indexing
	description: "Objects that ..."

class
	BEN_ROTATING_CONTAINER_TEST
	
inherit
	Q_TEST_CASE
	
	Q_HUD_CONTAINER_3D
	redefine
		draw
	end

creation
	make

feature
	name : STRING is "Container 3D Rotating"	
		
	init is
			-- Invoked when this test ist choosen.
		do
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is do
		result := void
	end
	
	draw( open_gl : Q_GL_DRAWABLE ) is
		local
			matrix_ : Q_MATRIX_4X4
			vector_ : Q_VECTOR_3D
		do
			create matrix_.identity
	--		matrix_.rotate( 0, 1, 0, open_gl.current_time_millis / 1000 )
	--		matrix_.translate( 0.5, 0, -1 )
	
			matrix_.rotate_at( 
				0, 1, 0, open_gl.time.current_time / 1000,
				0.5, 0.5, 0 )

--			matrix_.rotate_at( 
--				0, 1, 1, open_gl.current_time_millis / 1000,
--				0.5, 0.5, 0 )

			vector_ := matrix_.translation_3
			matrix_.translate( vector_.x, vector_.y, vector_.z - 1 )
	
			set_matrix( matrix_ )
			
			precursor( open_gl )
		end
		
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		local
			button_ : Q_HUD_BUTTON
			field_ : Q_HUD_TEXT_FIELD
			index_ : INTEGER
			
	--		matrix_ : Q_MATRIX_4X4
		do
			set_bounds( 0, 0, 1, 1 )
			
			from index_ := 1 until index_ = 3 loop
				create button_.make
				button_.set_font_size( 0.1 )
				button_.set_bounds( 0.1, index_ * 0.2, 0.8, 0.19 )
				button_.set_text( "This is Button " + index_.out )
				add( button_ )
				
				index_ := index_ + 1
			end
			

			from index_ := 3 until index_ = 5 loop
				create field_.make
				field_.set_font_size( 0.1 )
				field_.set_bounds( 0.1, index_ * 0.2, 0.8, 0.19 )
				add( field_ )
				
				index_ := index_ + 1
			end

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
end -- class BEN_ROTATING_CONTAINER_TEST
