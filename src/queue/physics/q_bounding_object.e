indexing
	description: "Superclass for bounding 'boxes' that want collsion detection"
	author: "Andreas Kaegi"

deferred class
	Q_BOUNDING_OBJECT

feature -- interface

	typeid: INTEGER is
			-- Type id of this bounding object type
			-- Not beautiful I know, but easier for the collision detector
			-- to distinguish between the different bounding object types
		deferred
		end		


feature {NONE} -- implementation

end -- class Q_BOUNDING_OBJECT
