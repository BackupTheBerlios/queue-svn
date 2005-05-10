indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Q_TEST_CASE_LIST
	
inherit
	ARRAYED_LIST[ Q_TEST_CASE ]
	rename
		make as list_make
	end
	

creation
	make
	
feature {NONE} -- creation
	make is
		do
			list_make( 10 )
			
			-- add here the test-cases
			extend( create {BEN_COLOR_CUBE_TEST} )
		end
		
	

end -- class Q_TEST_CASE_LIST
