indexing
	description: "Objects that represent a game mode like 8-Ball, 9-Ball, Snooker"
	author: "Severin Hacker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_MODE

feature -- Interface

	create_table : Q_TABLE is
			-- creates a table for this game mode
		deferred
		end
		
	
		

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end -- class Q_MODE
