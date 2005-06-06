indexing
	description: "Objects that represent a hole with balls"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HOLE

create
	make, make_from_points
	
feature 
	
	make(position_: Q_VECTOR_2D) is
			-- creation procedure
		do
			position := position_
			
			create caught_balls.make
		end
		
	make_from_points (positions_: ARRAY[Q_VECTOR_2D]) is
			-- create a hole from 3 points
		require
			positions_ /= void
		local
			index_ : INTEGER
		do
			create caught_balls.make
			
			create position.default_create
			from
				index_ := positions_.lower
			until
				index_ > positions_.upper
			loop
				position.add (positions_.item (index_))
				
				index_ := index_ + 1
			end
			
			position.scale (1.0 / index_)

			radius := (position - positions_.item (0)).length
		end
		
		
	position : Q_VECTOR_2D
		-- the position of the hole
		
	caught_balls: LINKED_LIST[Q_BALL]
		-- the balls that fell in this hole

	radius : DOUBLE
		-- the size of the hole
invariant
	position_set : position /= Void
	
end -- class HOLE
