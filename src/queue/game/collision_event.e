indexing
	description: "Objects that represent a collision or fall between two objects (bank,ball,hole) this is used in a list for collision tracking"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

class
	Q_COLLISION_EVENT

create
	make
	
feature -- Interface

	aggressor: Q_BALL -- the object that triggers the event, must be a ball
	defendent: Q_OBJECT -- the object that is hit, can be a ball, bank or hole
	
	make (aggressor_:Q_BALL; defendent_:Q_OBJECT) is
			-- creates a collision_event
		do
			aggressor := aggressor_
			defendent := defendent_
		end
		

feature {NONE} -- Implementation

invariant
	aggressor /= Void
	defendent /= Void

end -- class COLLISION_EVENT
