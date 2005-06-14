indexing
	description: ""
	author: "Andreas Kaegi"
	
class
	ACE_PHYS_TEST

inherit
	Q_TEST_CASE
	
feature -- interface

	name : STRING is "Physics Test"
		
	init is
			-- Invoked when this test ist choosen.
		local
			l: Q_LINE_2D
			b: BOOLEAN
			t: TUPLE[DOUBLE, DOUBLE]
		do
			create t.default_create
			create l.make (create {Q_VECTOR_2D}.make (0, 0), create {Q_VECTOR_2D}.make (100, 0))
			
			b := l.contains_k (create {Q_VECTOR_2D}.make (10, 0), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (-10, 0), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (10, 1), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (0, 0), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (100, 0), t)
			
			create l.make (create {Q_VECTOR_2D}.make (0, 0), create {Q_VECTOR_2D}.make (0, 100))
			
			b := l.contains_k (create {Q_VECTOR_2D}.make (10, 0), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (0, 0), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (0, 100), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (0, 20), t)
			b := l.contains_k (create {Q_VECTOR_2D}.make (0, 110), t)
			
		end
		
	initialized( root_ : Q_GL_ROOT ) is
			-- Called after the test-case is initialized. If you want, you
			-- can change some settings...
		local
			cam: Q_GL_CAMERA
		do
			cam ?= root_.transform
			
			cam.set_position (130, 70, 150)
			cam.set_alpha (0)
			cam.set_beta (0)
		end
		
	lighting : BOOLEAN is false

	object : Q_GL_OBJECT is
		do
			result := create {ACE_PHYS_TEST_OBJECT}.make
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

end -- class ACE_PHYS_TEST
