indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	Q_BOUNDING_OBJECT

feature -- interace

	typeid: INTEGER is
			-- Not beautiful I know, but easier for the collision detector
			-- to distinguish between the different bounding object types
		deferred
		end		

feature {NONE} -- implementation

end -- class Q_BOUNDING_OBJECT
