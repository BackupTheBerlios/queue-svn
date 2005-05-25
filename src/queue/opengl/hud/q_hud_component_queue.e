indexing
	description: "A Queue of hud-components, sorted by distanc to the screen"
	author: "Benjamin Sigg"

class
	Q_HUD_COMPONENT_QUEUE

feature
	root : Q_GL_ROOT
		-- root of the hud

feature{NONE} -- Queue & Stack
	list : ARRAYED_LIST[ TUPLE[ Q_HUD_COMPONENT, Q_PLANE ]]
		-- The (ordered) list of the components, and their 3-dimensional rectangle, in
		-- the form (component, position, width, height)

	stack : ARRAYED_LIST[ Q_MATRIX_4X4 ]
		-- The matrixes
		
	matrix : Q_MATRIX_4X4 is
		do
			result := stack.first
		end
		
feature{NONE} -- Math
	math : Q_GEOM_3D is
		once
			create result
		end
		
	tolerance : DOUBLE is 0.0001
		
	compare( first_, second_ : TUPLE[ Q_HUD_COMPONENT, Q_PLANE ] ) : DOUBLE is
			-- compares the position of two components. Returns the difference of the distanc
			-- "result = second_ - first_". So a positive value means, that first_ is nearer
			-- to the screen
		do
			
		end

end -- class Q_HUD_COMPONENT_QUEUE
