indexing
	description: "A description of a test-case"
	author: "Benjamin Sigg"

deferred class
	Q_TEST_CASE

feature -- to be implemented
	name : STRING is
			-- The name of this testcase. Its a good idea to choose a short name!
		deferred
		end
		
	init is
			-- Invoked when this test ist choosen.
		deferred
		end
		
	lighting : BOOLEAN is
			-- True if lighting should be enabled, false otherwise
		deferred
		end
		
	object : Q_GL_OBJECT is
			-- The Object to be displayed. This can be void, if the test 
			-- wants to do something of his own
		deferred
		end
	
	hud : Q_HUD_COMPONENT is
			-- A Hud-Component. The size of this component will not be changed.
			-- The value can be void, if the test does not need a hut
		deferred
		end
		
	max_bound : Q_VECTOR_3D is
			-- A vector, the maximal coordinates of the object.
			-- This method is only invoked if object does not return void
		deferred
		end
		
	min_bound : Q_VECTOR_3D is
			-- A vector, the minimal coordinates of the object.
			-- This method is only invoked if object does not return void
		deferred
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		deferred
		end
		

end -- class Q_TEST_CASE
