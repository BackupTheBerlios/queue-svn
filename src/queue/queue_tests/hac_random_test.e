indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HAC_RANDOM_TEST
	
inherit
	Q_TEST_CASE
	
feature
	
	name : STRING is "Random number test"
		
	init is
			-- Invoked when this test ist choosen.
		local
			i: INTEGER
			pos : INTEGER
			g : DOUBLE
			r_: Q_RANDOM
		do
			create r_
			from
				i := 1
			until
				i > 100
			loop
				g := r_.random_gaussian (0.0,1.0)
				if g.abs < 1 then
					pos := pos+1
				end
				io.put_double (g)
				io.put_new_line
				i := i+1
			end
			io.put_integer (pos)
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


end -- class HAC_RANDOM_TEST
