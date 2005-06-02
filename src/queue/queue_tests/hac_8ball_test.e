indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HAC_8BALL_TEST

inherit
	Q_TEST_CASE
	
feature
	
	name : STRING is "8Ball Test"
		
	init is
			-- Invoked when this test ist choosen.
		local
			table_: Q_TABLE
			balls_: ARRAY[Q_BALL]
			i: INTEGER
			eb_: Q_8BALL
		do
			create eb_.make
			table_ := eb_.table
			balls_ := table_.balls
			from
				i := 1
			until
				i >= balls_.count
			loop
				io.put_string(balls_.item (i).number.out+" "+balls_.item (i).center.out )
				io.put_new_line
				i := i+1
			end

		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		local
			cam: Q_GL_CAMERA
		do
			cam ?= root_.transform
			
			cam.set_position (200, 0, 400)
			cam.set_alpha (0)
			cam.set_beta (0)
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := void
		end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		do
			result := void
		end
		
	max_bound : Q_VECTOR_3D is
			-- A vector, the maximal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make(200, 200, 0)
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		do
			create result.make(0, 0, 0)
		end

end -- class HAC_8BALL_TEST
