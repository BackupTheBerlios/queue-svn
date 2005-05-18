indexing
	description: "Objects that ..."

class
	BEN_TIME_TEST
inherit
	Q_TEST_CASE
	redefine
		default_create
	end
	
	Q_HUD_LABEL
	redefine
		default_create,
		draw
	end

create
	default_create

feature{NONE}
	default_create is
			-- 
		do
			make
			set_insets( create {Q_HUD_INSETS}.make( 0.1, 0.1, 0.1, 0.1 ))
		end
		

feature
	draw( open_gl : Q_GL_DRAWABLE ) is
		do
--			set_text( open_gl.current_time_millis.out )
			set_text( open_gl.delta_time_millis.out + " - " + open_gl.current_time_millis.out )
			precursor( open_gl )
		end

	name : STRING is "Time"	
		
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
		do
			
			set_bounds( 0.1, 0.1, 0.8, 0.3 )
			
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


end -- class BEN_TIME_TEST
