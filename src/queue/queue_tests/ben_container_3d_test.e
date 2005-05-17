indexing
	description: "Objects that ..."
	
class
	BEN_CONTAINER_3D_TEST


inherit
	Q_TEST_CASE

feature
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
			font_ : Q_HUD_FONT
			container_3d_ : Q_HUD_CONTAINER_3D
			container_ : Q_HUD_CONTAINER
			button_ : Q_HUD_BUTTON
			field_ : Q_HUD_TEXT_FIELD
			index_ : INTEGER
		do
			font_ := create {Q_HUD_IMAGE_FONT}.make_standard( "Arial", 64, false, false );
			create container_.make
			container_.set_bounds( 0, 0, 1, 1 )
	
			-- first container		
			create container_3d_.make			
			container_3d_.matrix.rotate( 0, 1, 0, 1.2 )
			container_3d_.set_bounds( 0, 0, 1, 1 )
			container_.add( container_3d_ )
	
			from index_ := 1 until index_ = 5 loop
				create button_.make
				button_.set_font( font_ )
				button_.set_font_size( 0.1 )
				button_.set_bounds( 0.1, index_ * 0.2, 0.8, 0.19 )
				button_.set_text( "This is Button " + index_.out )
				container_3d_.add( button_ )
				
				index_ := index_ + 1
			end
			
			-- second container
			create container_3d_.make			
			container_3d_.set_bounds( 0, 0, 1, 1 )
			container_3d_.matrix.rotate( 0, 1, 0, -1.0 )
			container_3d_.matrix.translate( 0.35, 0, -1.0 )
			container_.add( container_3d_ )
	
			from index_ := 1 until index_ = 5 loop
				create field_.make
				field_.set_font( font_ )
				field_.set_font_size( 0.1 )
				field_.set_bounds( 0.1, index_ * 0.2, 0.8, 0.19 )
				field_.set_text( index_.out )
				container_3d_.add( field_ )
				
				index_ := index_ + 1
			end	
	
			result := container_
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
