indexing
	description: "The result of a search in a q_hud_component_queue"
	author: "Benjamin Sigg"

class
	Q_HUD_QUEUE_SEARCH_RESULT

creation
	make, make_empty

feature {NONE}
	make_empty is
		do
			
		end
		
	make( index_ : INTEGER; component_ : Q_HUD_COMPONENT; position_ : Q_VECTOR_2D ) is
		do
			set_index( index_ )
			set_component( component_ )
			set_position( position_ )
		end
		
feature
	component : Q_HUD_COMPONENT
	index : INTEGER
	position : Q_VECTOR_2D
	
	set_component( component_ : Q_HUD_COMPONENT ) is
		do
			component := component_
		end
		
	set_index( index_ : INTEGER ) is
		do
			index := index_
		end
		
	set_position( position_ : Q_VECTOR_2D ) is
		do
			position := position_
		end
		
end -- class Q_HUD_QUEUE_SEARCH_RESULT
