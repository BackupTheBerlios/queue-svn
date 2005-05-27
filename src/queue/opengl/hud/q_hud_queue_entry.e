indexing
	description: "Helperclass"
	author: "Benjamin Sigg"

class
	Q_HUD_QUEUE_ENTRY

feature{Q_HUD_QUEUE}
	component : Q_HUD_COMPONENT
	
	set_component( component_ : Q_HUD_COMPONENT ) is
		do
			component := component_
		end
		
	matrix : Q_MATRIX_4X4
	
	set_matrix( matrix_ : Q_MATRIX_4X4 ) is
		do
			matrix := matrix_
		end
		
	vectorized_plane : Q_VECTORIZED_PLANE
	
	set_vectorized_plane( plane_ : Q_VECTORIZED_PLANE ) is
		do
			vectorized_plane := plane_
		end
		

end -- class Q_HUD_QUEUE_ENTRY
