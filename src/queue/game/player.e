indexing
	description: "Objects that represent a billard player"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_PLAYER

	
feature -- Interface

	name : STRING -- the name of the player
	
	set_name(name_: STRING) is
			-- sets the name of the player
		do
			name := name_
		ensure
			name = name_
		end

		

feature {NONE} -- Implementation

invariant
	name_set : name /= Void

end -- class PLAYER
