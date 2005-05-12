indexing
	description: "A description of a border"
	author: "Benjamin Sigg"
	revision: "1.0"

class
	Q_HUD_INSETS
	
creation
	make, make_empty, make_copy
	
feature{NONE} -- creation
	make_empty is
		do
			make( 0, 0, 0, 0 )
		end
	
	make( top_, left_, bottom_, right_ : DOUBLE ) is
		do
			set( top_, left_, bottom_, right_ )
		end
		
	make_copy( insets_ : Q_HUD_INSETS ) is
		do
			make( insets_.top, insets_.left, insets_.bottom, insets_.right )
		end
		
feature -- values
	top, bottom, left, right : DOUBLE
	
	set( top_, left_, bottom_, right_ : DOUBLE ) is
		do
			set_top( top_ )
			set_left( left_ )
			set_bottom( bottom_ )
			set_right( right_ )
		end
		
	
	set_top( top_ : DOUBLE ) is
		do
			top := top_
		end
		
	set_bottom( bottom_ : DOUBLE ) is
		do
			bottom := bottom_
		end
		
	set_left( left_ : DOUBLE ) is
		do
			left := left_
		end
		
	set_right( right_ : DOUBLE ) is
		do
			right := right_
		end
		

end -- class Q_HUD_INSETS
