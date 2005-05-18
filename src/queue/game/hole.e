indexing
	description: "Objects that represent a hole with balls"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_HOLE

create
	make
	
feature 
	
	make(position_: Q_VECTOR_2D) is
			-- creation procedure
		do
			position := position_
		end
		
	position : Q_VECTOR_2D
	caught_balls: ARRAY[Q_BALL] -- the balls that fell in this hole

invariant
	position_set : position /= Void
	
end -- class HOLE
